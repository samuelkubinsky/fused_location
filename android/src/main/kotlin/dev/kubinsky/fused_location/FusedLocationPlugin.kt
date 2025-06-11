//
//  FusedLocationPlugin.kt
//  fused_location
//
//  Created by Samuel Kubinský on 09/06/2025.
//

package dev.kubinsky.fused_location

import android.annotation.SuppressLint
import android.content.Context
import android.location.Location
import android.os.Build
import android.os.Looper
import androidx.annotation.ChecksSdkIntAtLeast
import androidx.core.content.ContextCompat
import com.google.android.gms.location.DeviceOrientation
import com.google.android.gms.location.DeviceOrientationListener
import com.google.android.gms.location.DeviceOrientationRequest
import com.google.android.gms.location.FusedLocationProviderClient
import com.google.android.gms.location.FusedOrientationProviderClient
import com.google.android.gms.location.LocationCallback
import com.google.android.gms.location.LocationRequest
import com.google.android.gms.location.LocationResult
import com.google.android.gms.location.LocationServices
import com.google.android.gms.location.Priority
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlin.math.abs

class FusedLocationPlugin: FlutterPlugin, MethodCallHandler, StreamHandler {
  // Flutter
  private lateinit var context : Context
  private lateinit var methodChannel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private var eventSink: EventSink? = null

  // Providers
  private lateinit var locationProviderClient: FusedLocationProviderClient
  private lateinit var orientationProviderClient: FusedOrientationProviderClient

  // Callbacks
  private var locationCallback: LocationCallback? = null
  private var orientationListener: DeviceOrientationListener? = null

  // Current state
  private var lastLocation: Location? = null
  private var lastOrientation: DeviceOrientation? = null

  override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    context = flutterPluginBinding.applicationContext

    methodChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "fused_location")
    methodChannel.setMethodCallHandler(this)

    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "fused_location/stream")
    eventChannel.setStreamHandler(this)

    locationProviderClient = LocationServices.getFusedLocationProviderClient(context)
    orientationProviderClient = LocationServices.getFusedOrientationProviderClient(context)
  }

  override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
    methodChannel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  override fun onMethodCall(call: MethodCall, result: Result) {
    when (call.method) {
      "startLocationUpdates" -> {
        val distanceFilter = call.argument<Double>("distanceFilter")?.toFloat() ?: 0f
        startLocationUpdates(distanceFilter)
        startOrientationUpdates()
        result.success(null)
      }
      "stopLocationUpdates" -> {
        stopLocationUpdates()
        stopOrientationUpdates()
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onListen(arguments: Any?, events: EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {
    eventSink = null
  }

  @SuppressLint("MissingPermission")
  private fun startLocationUpdates(distanceFilter: Float?) {
    stopLocationUpdates()

    val distanceFilter = distanceFilter ?: 0f

    locationCallback = object : LocationCallback() {
      override fun onLocationResult(result: LocationResult) {
        result.lastLocation?.let { location ->
          lastLocation = location
          notifySubscribers()
        }
      }
    }

    val locationRequest = LocationRequest.Builder(
      Priority.PRIORITY_HIGH_ACCURACY,
      1000L
    ).apply {
      setWaitForAccurateLocation(false)
      setMinUpdateIntervalMillis(500L)
      setMaxUpdateDelayMillis(2000L)
      setMinUpdateDistanceMeters(distanceFilter)
    }.build()

    val looper = Looper.getMainLooper()

    locationProviderClient.requestLocationUpdates(
      locationRequest,
      locationCallback!!,
      looper
    )
  }

  private fun startOrientationUpdates() {
    stopOrientationUpdates()

    val request = DeviceOrientationRequest.Builder(
      DeviceOrientationRequest.OUTPUT_PERIOD_DEFAULT
    ).build()

    val executor = ContextCompat.getMainExecutor(context)

    orientationListener = DeviceOrientationListener { orientation ->
      val shouldUpdate = lastOrientation?.let { last ->
        abs(last.headingDegrees - orientation.headingDegrees) > 1
      } ?: true

      if (shouldUpdate) {
        lastOrientation = orientation
        notifySubscribers()
      }
    }

    orientationProviderClient.requestOrientationUpdates(
      request,
      executor,
      orientationListener!!
    )
  }

  private fun stopLocationUpdates() {
    locationCallback?.let { callback ->
      locationProviderClient.removeLocationUpdates(callback)
    }
    locationCallback = null
  }

  private fun stopOrientationUpdates() {
    orientationListener?.let { listener ->
      orientationProviderClient.removeOrientationUpdates(listener)
    }
    orientationListener = null
  }

  private fun notifySubscribers() {
    val eventSink = eventSink ?: return
    val location = lastLocation ?: return
    val orientation = lastOrientation ?: return

    // position
    val positionLatitude = location.latitude
    val positionLongitude = location.longitude
    var positionAccuracy = -1.0
    if (location.hasAccuracy()) {
      positionAccuracy = location.accuracy.toDouble()
    }

    // elevation
    var elevationMeanSeaLevel = -1.0
    var elevationMeanSeaLevelAccuracy = -1.0
    var elevationEllipsoidal = -1.0
    var elevationEllipsoidalAccuracy = -1.0
    if (isAtLeastU() && location.hasMslAltitude()) {
      elevationMeanSeaLevel = location.mslAltitudeMeters
    }
    if (isAtLeastU() && location.hasMslAltitudeAccuracy()) {
      elevationMeanSeaLevelAccuracy = location.mslAltitudeAccuracyMeters.toDouble()
    }
    if (location.hasAltitude()) {
      elevationEllipsoidal = location.altitude
    }
    if (isAtLeastO() && location.hasVerticalAccuracy()) {
      elevationEllipsoidalAccuracy = location.verticalAccuracyMeters.toDouble()
    }

    // course
    var courseDirection = -1.0
    var courseAccuracy = -1.0
    if (location.hasBearing()) {
      courseDirection = location.bearing.toDouble()
    }
    if (isAtLeastO() && location.hasBearingAccuracy()) {
      courseAccuracy = location.bearingAccuracyDegrees.toDouble()
    }

    // speed
    var speedMagnitude = -1.0
    var speedAccuracy = -1.0
    if (location.hasSpeed()) {
      speedMagnitude = location.speed.toDouble()
    }
    if (isAtLeastO() && location.hasSpeedAccuracy()) {
      speedAccuracy = location.speedAccuracyMetersPerSecond.toDouble()
    }

    // heading
    val headingDirection = orientation.headingDegrees.toDouble()
    val headingAccuracy = orientation.headingErrorDegrees.toDouble()

    // result
    val map = mapOf<String, Double>(
      "positionLatitude" to positionLatitude,
      "positionLongitude" to positionLongitude,
      "positionAccuracy" to positionAccuracy,
      "elevationMeanSeaLevel" to elevationMeanSeaLevel,
      "elevationMeanSeaLevelAccuracy" to elevationMeanSeaLevelAccuracy,
      "elevationEllipsoidal" to elevationEllipsoidal,
      "elevationEllipsoidalAccuracy" to elevationEllipsoidalAccuracy,
      "courseDirection" to courseDirection,
      "courseAccuracy" to courseAccuracy,
      "speedMagnitude" to speedMagnitude,
      "speedAccuracy" to speedAccuracy,
      "headingDirection" to headingDirection,
      "headingAccuracy" to headingAccuracy
    )

    eventSink.success(map)
  }

  @ChecksSdkIntAtLeast(api = 26)
  fun isAtLeastO(): Boolean {
    return Build.VERSION.SDK_INT >= Build.VERSION_CODES.O
  }

  @ChecksSdkIntAtLeast(api = 34)
  fun isAtLeastU(): Boolean {
    return Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE
  }
}
