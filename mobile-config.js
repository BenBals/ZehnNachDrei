App.accessRule('*');

App.info({
  name: 'ZehnNachDrei',
  id: 'de.zehnnachdrei.zehnnachdrei',
  description: 'Die App der Schülerzeitung des CJD Rostock.',
  author: 'ZehnNachDrei',
  email: 'redaktion@zehnnachdrei.de',
  website: 'http://zehnnachdrei.de',
  version: '0.1.19'
});

App.icons({
  'iphone_2x': 'resources/icon/iOS_icon_iPhone_2x.png',
  'iphone_3x': 'resources/icon/iOS_icon_iPhone_3x.png',

  'ipad': 'resources/icon/iOS_icon_iPad.png',
  'ipad_2x': 'resources/icon/iOS_icon_iPad_2x.png',
  'ipad_pro': 'resources/icon/iOS_icon_iPad_pro.png',

  'android_mdpi': 'resources/icon/android_icon_mdpi.png',
  'android_hdpi': 'resources/icon/android_icon_hdpi.png',
  'android_xhdpi': 'resources/icon/android_icon_xhdpi.png'
});


App.launchScreens({
  'iphone_2x': 'resources/splash/iPhone4@2x.png',
  'iphone5': 'resources/splash/iPhone5.png',
  'iphone6': 'resources/splash/iPhone6.png',
  'iphone6p_portrait': 'resources/splash/iPhone6plus-Portrait.png',
  'iphone6p_landscape': 'resources/splash/iPhone6plus-Landscape.png',

  'ipad_portrait': 'resources/splash/iPad-Portrait.png',
  'ipad_portrait_2x': 'resources/splash/iPad-Portrait@2x.png',
  'ipad_landscape': 'resources/splash/iPad-Landscape.png',
  'ipad_landscape_2x': 'resources/splash/iPad-Landscape@2x.png',

  'android_mdpi_portrait': 'resources/splash/android_mdpi_portrait.png',
  'android_mdpi_landscape': 'resources/splash/android_mdpi_landscape.png',
  'android_hdpi_portrait': 'resources/splash/android_hdpi_portrait.png',
  'android_hdpi_landscape': 'resources/splash/android_hdpi_landscape.png',
  'android_xhdpi_portrait': 'resources/splash/android_xhdpi_portrait.png',
  'android_xhdpi_landscape': 'resources/splash/android_xhdpi_landscape.png'

});

App.setPreference('StatusBarOverlaysWebView', 'false');
App.setPreference('StatusBarBackgroundColor', '#087DDA');
App.setPreference('StatusBarStyle', 'lightcontent');
