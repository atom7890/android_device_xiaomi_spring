/*
 * SPDX-FileCopyrightText: The Android Open Source Project
 * SPDX-License-Identifier: Apache-2.0
 */

// The AOSP Bluetooth audio provider, registered normally. The PenguinOS copy of
// hardware/interfaces/bluetooth/audio/aidl/default/service.cpp returns an error
// before registering anything, so the vendor audio service never gets a provider
// factory and A2DP has no output. Every other file in this directory is the unmodified
// AOSP source from that directory.

#define LOG_TAG "BtAudioAIDLService"

#include <android/binder_manager.h>
#include <android/binder_process.h>
#include <utils/Log.h>

#include "BluetoothAudioProviderFactory.h"

using ::aidl::android::hardware::bluetooth::audio::BluetoothAudioProviderFactory;

extern "C" __attribute__((visibility("default"))) binder_status_t
createIBluetoothAudioProviderFactory() {
    auto factory = ::ndk::SharedRefBase::make<BluetoothAudioProviderFactory>();
    const std::string instance_name =
            std::string() + BluetoothAudioProviderFactory::descriptor + "/default";
    binder_status_t aidl_status =
            AServiceManager_addService(factory->asBinder().get(), instance_name.c_str());
    ALOGW_IF(aidl_status != STATUS_OK, "Could not register %s, status=%d", instance_name.c_str(),
             aidl_status);
    return aidl_status;
}
