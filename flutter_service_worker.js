'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "2faccf020f0c82bad72108fe91ca46ac",
"assets/AssetManifest.bin.json": "662457f88e49b3d7a2ffddbfeb32c686",
"assets/AssetManifest.json": "ebea1a1c2c730065dcd08e34707c0e9b",
"assets/assets/covers/Screens_cover.png": "bbde33fad227723648ebb04202bf479d",
"assets/assets/covers/Screens_cover.svg": "9358587dd3a6e950dee25c79a67f2e50",
"assets/assets/icons/add.svg": "317af32adc3065545380442e09945d3d",
"assets/assets/icons/attachment-svgrepo-com.svg": "577c14b5d8f589e166213d95f220f904",
"assets/assets/icons/chat.svg": "8909c29fabae07ef11ebdbc2c128e3c5",
"assets/assets/icons/delete.svg": "f4c2b19ffd43e167cb6e10a86a730e16",
"assets/assets/icons/edit.svg": "0b3b30a7ee4b6be169521f466aa00e0e",
"assets/assets/icons/eye-lock.svg": "f312696c5f0a3ab8b32deb83aeda56ff",
"assets/assets/icons/eye-see.svg": "0de41e0ec06e46a8f0ebc598baa3a637",
"assets/assets/icons/google-color-svgrepo-com.svg": "1651d8b87f0961b52b759a8169341659",
"assets/assets/icons/home.svg": "4b28899f03c099254f81e023d2d6cefc",
"assets/assets/icons/id-card-clip-svgrepo-com.svg": "e95460949e3b3805cecdca3665b1625f",
"assets/assets/icons/inpox.svg": "e2d0b4aac3bb3bd7f981627e9e4f8a2c",
"assets/assets/icons/location-pin-alt-svgrepo-com.svg": "9c11827a256e7efbd73679ca36cb8441",
"assets/assets/icons/lock.svg": "bb45dd48076210b79cc21ebdcb66609e",
"assets/assets/icons/mic-svgrepo-com.svg": "767ce93cf558a479013e192d8b2bba3d",
"assets/assets/icons/mnt.svg": "df476f7dce3795ab1188e6b0e6294592",
"assets/assets/icons/notifications.svg": "1eb7490e59d58d5e49fe9c2fc0ed02a2",
"assets/assets/icons/option-svgrepo-com.svg": "4a46c63847eba888b313eadceb181e59",
"assets/assets/icons/phone-svgrepo-com.svg": "e62e46a1b66471cdb712ec333bb5870f",
"assets/assets/icons/send-1-svgrepo-com.svg": "8cbc0932cb78f2bab919a2c3864a197d",
"assets/assets/icons/shop.svg": "dbbaeb8a1dcfaeeff04eb10f22664862",
"assets/assets/icons/user.svg": "b69216a05f7be74029b1b6216c1864db",
"assets/assets/images/apple%2520%25201.png": "a7805ba5b197763b73b3b4636fe1d121",
"assets/assets/images/apple_logo.png": "1e3c4773b5c56480f5dab0d9639f9fcd",
"assets/assets/images/cars/Chevrolet_Aveo_2014_2020.png": "c265dcfb30545c7eda6032933adac077",
"assets/assets/images/cars/Chevrolet_Optra_2015_2023.png": "599d9464ead58ea651b60759e9b17355",
"assets/assets/images/cars/default_car.png": "1c1708fa536a2446033512ec6a0b762c",
"assets/assets/images/cars/Fiat_Tipo_2017_2021.png": "ba1f8b49b0ce44d39dec1bb87ab0a2a1",
"assets/assets/images/cars/fiat_tipo_2018.png": "fbb17d900acf0b48035371af60cace83",
"assets/assets/images/cars/Fiat_Tipo_2022_2025.png": "9305b409a077cdc54c7c7dc66734d4c8",
"assets/assets/images/cars/Hyundai_Accent_RB_2014_2025.png": "eefd879ba63086eed8e41dbadb448ad1",
"assets/assets/images/cars/Hyundai_Elantra_AD_2015_2016.png": "b111b993db6067319fbcbb96c50f32df",
"assets/assets/images/cars/Hyundai_Elantra_AD_2017_2018.png": "bcd61b71c2f8a3454f255c1cb6e635fb",
"assets/assets/images/cars/Hyundai_Elantra_AD_2017_2022.png": "2f833902f9240b32e72d8ce3beb4f7c8",
"assets/assets/images/cars/Hyundai_Elantra_AD_2019_2025.png": "107c61059c1d5ed2d28e0cd1e996f52a",
"assets/assets/images/cars/Hyundai_Elantra_AD_2023_2025.png": "58b6079e0ae6a6487f63b4d6045c36e8",
"assets/assets/images/cars/Hyundai_Elantra_CN7_2021_2025.png": "c9197565cfd08ef92f113319b418afee",
"assets/assets/images/cars/Hyundai_Elantra_HD_2017_2024.png": "26d04fc653ea531d70ac471bc4c4797a",
"assets/assets/images/cars/Hyundai_Tucson_2017_2020.png": "1c1708fa536a2446033512ec6a0b762c",
"assets/assets/images/cars/Hyundai_Tucson_2021_2025.png": "19882936bbf6c0ce270da8c6fef8751a",
"assets/assets/images/cars/Kia_Cerato_2014_2018.png": "aa5f8969d7123e73311c820498ce6187",
"assets/assets/images/cars/Kia_Cerato_2019_2021.png": "28aeebf6edebb5468a53f59fb70bf330",
"assets/assets/images/cars/Kia_Cerato_2022_2024.png": "287783950796fd9cb1b30de262a43a2f",
"assets/assets/images/cars/Kia_Rio_2014_2020.png": "0ad04a3f4dd6f8911bf5f1f9302c92b3",
"assets/assets/images/cars/Kia_Sportage_2015_2016.png": "809adbc3a63c999e9582150f0362dabf",
"assets/assets/images/cars/Kia_Sportage_2017_2022.png": "0d0713c0a794cf21ab672cca366933f9",
"assets/assets/images/cars/Kia_Sportage_2023_2025.png": "97d50ec58ad4468737e0b4f8b35eeec9",
"assets/assets/images/cars/MG_5_2020_2025.png": "486ad4b2f4b5e2b42b1fc6f9540cd328",
"assets/assets/images/cars/MG_5_2020_202522.png": "77dffff0b4ad8524cc3bd3b10910350b",
"assets/assets/images/cars/MG_ZS_2019_2025.png": "e80c3bf2b3b17a9295d3931b3a631d60",
"assets/assets/images/cars/Nissan_Sentra_2015_2025.png": "d7273585280491588eb16ce1ec55d805",
"assets/assets/images/cars/Nissan_Sunny_2017_2025.png": "e18a68756c1c594adede1f2c5a2f4e47",
"assets/assets/images/cars/Renault_Megane_2017_2025.png": "52dee22c0fc4576d8953c4aa7889e8b7",
"assets/assets/images/cars/Toyota_Corolla_2015_2018.png": "9f5c67b57a94a3da60357d45ffcb8677",
"assets/assets/images/cars/Toyota_Corolla_2019_2025.png": "3ffe2c7c37fce62afbf6f96f853505ec",
"assets/assets/images/cars/Toyota_Yaris_2015_2019.png": "fb78f253067cfa75dd2c9779f8a41678",
"assets/assets/images/chatbot_icon.png": "4e042728dcf544913ec4abf09bec5b0a",
"assets/assets/images/default_car.png": "7fb1c81fb441532900c8134910fd0aec",
"assets/assets/images/Gemini_icon.png": "efc4a5f21b1f5e1eebd1b9485f0b7b1b",
"assets/assets/images/google%25201.png": "b32bf9e8d421bed3b7a9e861839d7339",
"assets/assets/images/Google_logo.png": "51791544f2482d53a28225ae7ef91dfe",
"assets/assets/images/hide%25201.png": "6e80a28b3f3921fb63fc2ab985c229dd",
"assets/assets/images/Hyundai.png": "dbbbb2fe4db1c3f1e2ba5b1db3e8c952",
"assets/assets/images/Hyundair.png": "8d760dce9f4268c709afbbd2927d86fb",
"assets/assets/images/inbox%25201.png": "84f9f0451c18ab1e60495e14c1301353",
"assets/assets/images/lock%25201.png": "4d191aca99c54b0acdbd4b3ad9d0f1e9",
"assets/assets/images/logo.png": "e7c53013c40f4bb20dc1247a79f9d029",
"assets/assets/images/logo_text.png": "ce9171c6dcb9e2bc6082cf02ab1ebe5b",
"assets/assets/images/maintenance.png": "58bda2cf44f8ae264bbe1c3d01a969e9",
"assets/assets/images/motor_oil.png": "d6c682c1e7debb93c28d70a78dca9e56",
"assets/assets/images/offer.jpg": "aee2221ee72a6bf03d2a32ac4d7f5558",
"assets/assets/svg/add.svg": "9b765b67b9d750b58e7cdbc6cf2624dd",
"assets/assets/svg/attachment.svg": "520fd5b8a880463396cab911d204fb37",
"assets/assets/svg/chat.svg": "225d3b15c3a402a19f93882336a886ff",
"assets/assets/svg/delete.svg": "0ca1744a44ced57c3e4348e29cd98812",
"assets/assets/svg/edit.svg": "0b3b30a7ee4b6be169521f466aa00e0e",
"assets/assets/svg/eye-lock.svg": "f312696c5f0a3ab8b32deb83aeda56ff",
"assets/assets/svg/eye-see.svg": "0de41e0ec06e46a8f0ebc598baa3a637",
"assets/assets/svg/home.svg": "4b28899f03c099254f81e023d2d6cefc",
"assets/assets/svg/id.svg": "f29f40ebce5a458b14af68382e6d5bfb",
"assets/assets/svg/inpox.svg": "e2d0b4aac3bb3bd7f981627e9e4f8a2c",
"assets/assets/svg/location.svg": "4191eebe8d98a19c707624e13eeac83b",
"assets/assets/svg/lock.svg": "87533643f079d5240c84af4ad2ff9f2f",
"assets/assets/svg/Maint.svg": "b383728a666e4590579a49bbe2d53f7a",
"assets/assets/svg/mic.svg": "ffaa156b45acd4773557bd095d2de26b",
"assets/assets/svg/mnt.svg": "5d37221624c0fc972eda8df35ace3abb",
"assets/assets/svg/new%2520chat.svg": "d83b4587c902e4e553f105e3508fb5e8",
"assets/assets/svg/notification.svg": "a60ce595f966f6a3642226cbc335807f",
"assets/assets/svg/offer.svg": "9dc2fde4c7c7fb483bd16d1dc800fd33",
"assets/assets/svg/options.svg": "a3e80e9a0795c1d77e6242c31063e7ba",
"assets/assets/svg/search.svg": "d3cc3d99f24f33171f8fc71a7b72b95e",
"assets/assets/svg/send.svg": "a7181dc7e7ded6cc0c88f0be5b87eefb",
"assets/assets/svg/shop.svg": "dbbaeb8a1dcfaeeff04eb10f22664862",
"assets/assets/svg/shoplocation.svg": "b15e9444fc750b6514995a81d6a14908",
"assets/assets/svg/shopname.svg": "7722d9f0f28fca6f20998c6d071270b8",
"assets/assets/svg/shopphone.svg": "e62e46a1b66471cdb712ec333bb5870f",
"assets/assets/svg/side.svg": "5510b66029a5af5c5d3a28af1816ee94",
"assets/assets/svg/user.svg": "b69216a05f7be74029b1b6216c1864db",
"assets/assets/svg/username.svg": "14caf87fca3ac441d3e89ae545f87926",
"assets/assets/svg/viewall.svg": "099ab7e6cd9c6e8cee2c9d4391034357",
"assets/assets/svg/wrench2.svg": "3e4101b6bfa501ecf1b349eb1a29aa7c",
"assets/assets/svg/wrench4.svg": "76bdcf52656acee82b4326935b92a48a",
"assets/assets/svg/wrench5.svg": "8567243b6b43447682c7415b37503fdc",
"assets/assets/svg/wrench6.svg": "e529d6044ac787f2600fcd6a9135a5ab",
"assets/FontManifest.json": "dc3d03800ccca4601324923c0b1d6d57",
"assets/fonts/MaterialIcons-Regular.otf": "c0da3a127f70e3f51374a4e151e0e0fa",
"assets/NOTICES": "2e0e48ac0422031791a42e55ecc4a46e",
"assets/packages/awesome_dialog/assets/flare/error.flr": "e3b124665e57682dab45f4ee8a16b3c9",
"assets/packages/awesome_dialog/assets/flare/info.flr": "bc654ba9a96055d7309f0922746fe7a7",
"assets/packages/awesome_dialog/assets/flare/info2.flr": "21af33cb65751b76639d98e106835cfb",
"assets/packages/awesome_dialog/assets/flare/info_without_loop.flr": "cf106e19d7dee9846bbc1ac29296a43f",
"assets/packages/awesome_dialog/assets/flare/question.flr": "1c31ec57688a19de5899338f898290f0",
"assets/packages/awesome_dialog/assets/flare/succes.flr": "ebae20460b624d738bb48269fb492edf",
"assets/packages/awesome_dialog/assets/flare/succes_without_loop.flr": "3d8b3b3552370677bf3fb55d0d56a152",
"assets/packages/awesome_dialog/assets/flare/warning.flr": "68898234dacef62093ae95ff4772509b",
"assets/packages/awesome_dialog/assets/flare/warning_without_loop.flr": "c84f528c7e7afe91a929898988012291",
"assets/packages/awesome_dialog/assets/rive/error.riv": "e74e21f8b53de4b541dd037c667027c1",
"assets/packages/awesome_dialog/assets/rive/info.riv": "2a425920b11404228f613bc51b30b2fb",
"assets/packages/awesome_dialog/assets/rive/info_reverse.riv": "c6e814d66c0e469f1574a2f171a13a76",
"assets/packages/awesome_dialog/assets/rive/question.riv": "00f02da4d08c2960079d4cd8211c930c",
"assets/packages/awesome_dialog/assets/rive/success.riv": "73618ab4166b406e130c2042dc595f42",
"assets/packages/awesome_dialog/assets/rive/warning.riv": "0becf971559a68f9a74c8f0c6e0f8335",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/dash_chat_2/assets/placeholder.png": "ce1fece6c831b69b75c6c25a60b5b0f3",
"assets/packages/dash_chat_2/assets/profile_placeholder.png": "77f5794e2eb49f7989b8f85e92cfa4e0",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/flutter_map/lib/assets/flutter_map_logo.png": "208d63cc917af9713fc9572bd5c09362",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "5dcef449791fa27946b3d35ad8803796",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "58c59e24b9cbe22ab4563a77d4ea05c5",
"icons/Icon-192.png": "ac9a721a12bbc803b44f645561ecb1e1",
"icons/Icon-512.png": "96e752610906ba2a93c65f8abe1645f1",
"icons/Icon-maskable-192.png": "c457ef57daa1d16f64b27b786ec2ea3c",
"icons/Icon-maskable-512.png": "301a7604d45b3e739efc881eb04896ea",
"index.html": "2067110d7444ea5df8bbba4e4192409b",
"/": "2067110d7444ea5df8bbba4e4192409b",
"main.dart.js": "25e5f1348300eca44c231bba1a0eaa17",
"manifest.json": "8cd6664a57af30e0f341ba3e12bb3311",
"splash/img/dark-1x.png": "9d4f41e38a31eab0af39f92093be6099",
"splash/img/dark-2x.png": "38536b22b05c8e4aa8f64c3b00d32be7",
"splash/img/dark-3x.png": "29a1f72ea4b555662d8bb38214bc1880",
"splash/img/dark-4x.png": "ca01ea9dad83ef550bde030fc894d9f4",
"splash/img/light-1x.png": "9d4f41e38a31eab0af39f92093be6099",
"splash/img/light-2x.png": "38536b22b05c8e4aa8f64c3b00d32be7",
"splash/img/light-3x.png": "29a1f72ea4b555662d8bb38214bc1880",
"splash/img/light-4x.png": "ca01ea9dad83ef550bde030fc894d9f4",
"version.json": "52f2773fc54f6a0d829ee1d7be886c7e"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
