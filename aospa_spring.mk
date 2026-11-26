#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#
# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Platform required during product configuration
TARGET_BOARD_PLATFORM := blair
TARGET_KERNEL_VERSION := 6.1
TARGET_USES_KERNEL_PLATFORM := false

# Use the UFS BSG interface with the prebuilt 6.1 kernel headers.
$(call soong_config_set,ufsbsg,ufsframework,bsg)

# Qualcomm system-side perf stack: the QPerformance and UxPerformance boot jars, the
# perfservice daemon, the client libraries and the perf properties. Without it the
# framework logs ClassNotFoundException for com.qualcomm.qti.Performance and cannot use the
# vendor perf HAL. On by default. Turn it off for one build with:
#   SPRING_QTI_PERF=false ./vendor/aospa/build.sh spring -g
# The stock vendor perf HAL stays as it is (TARGET_PROVIDES_QTI_PERF_BLOBS). This must be
# set here, before aospa-target.mk is inherited, because components.mk reads it there.
SPRING_QTI_PERF ?= true
ifeq ($(SPRING_QTI_PERF),true)
TARGET_COMMON_QTI_COMPONENTS += perf
TARGET_PROVIDES_QTI_PERF_BLOBS := true
endif

# Inherit some common PenguinOS / AOSPA stuff.
TARGET_USES_BLUR := true
$(call inherit-product, vendor/aospa/target/product/aospa-target.mk)

# Inherit from spring device
$(call inherit-product, device/xiaomi/spring/device.mk)

# Device identifiers
PRODUCT_DEVICE := spring
PRODUCT_NAME := aospa_spring
PRODUCT_BRAND := Redmi
PRODUCT_MODEL := 25057RN09G
PRODUCT_MANUFACTURER := Xiaomi

PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="spring_global-user 16 BP2A.250605.031.A3 16OS3.1.260915.200026040.QCPEGL.S release-keys" \
    BuildFingerprint=Xiaomi/spring_global/spring:16/BP2A.250605.031.A3/16OS3.1.260915.200026040.QCPEGL.S:user/release-keys \
    DeviceName=spring \
    DeviceProduct=spring_global

# GMS
PRODUCT_GMS_CLIENTID_BASE := android-xiaomi
