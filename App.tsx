import React, { useEffect } from 'react';
import { View, Text, StyleSheet, AppState, AppStateStatus, PermissionsAndroid, Alert, Linking, Platform } from 'react-native';
import { NativeModules } from 'react-native';

const { MyNativeModules } = NativeModules;

const App: React.FC = () => {

  const requestCameraPermission = async () => {
    try {
      const checkNotificationPermission = await PermissionsAndroid.check(PermissionsAndroid.PERMISSIONS.POST_NOTIFICATIONS);
      if (!checkNotificationPermission) {
        const requestPermissionStatus = await PermissionsAndroid.request(PermissionsAndroid.PERMISSIONS.POST_NOTIFICATIONS);
        if (requestPermissionStatus === 'never_ask_again') {
          Alert.alert('Permission Alert', 'Notification permission is not granted, Please enable permission from mobile settings', [
            {
              text: 'Go To Settings',
              onPress: () => Linking.openSettings(),
            }

          ], { cancelable: true },)
        }
      }
    } catch (err) {
      console.warn(err);
    }
  };

  useEffect(() => {
    const handleAppStateChange = (nextAppState: AppStateStatus) => {
      if (Platform.OS === 'android' ? nextAppState.match(/inactive|background/) : nextAppState.match(/background/)) {
        MyNativeModules?.onNotification();
      }
    };
    const subscription = AppState.addEventListener('change', handleAppStateChange);
    return () => {
      subscription.remove();
    };
  }, []);

  useEffect(() => {
    Platform.OS === 'android' ? requestCameraPermission() : MyNativeModules?.requestNotificationPermission();
  }, [])

  return (
    <View style={styles.container}>
      <Text style={styles.buttonText}>Challenge: Native Bridging for Local Push Notification on App Kill</Text>
    </View>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    backgroundColor: '#fff',
    marginHorizontal: 20
  },
  buttonText: {
    color: '#000',
    fontSize: 16,
    textAlign: 'center'
  },
});

export default App;
