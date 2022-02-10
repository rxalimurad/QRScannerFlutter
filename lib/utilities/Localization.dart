 import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import 'DataCacheManager.dart';

setApplicationLanguage() {
  String locale = Get.deviceLocale?.languageCode ?? "";
  print("locale : $locale");
  if (locale.contains("es")) {
    DataCacheManager.language = Spanish();
  } else  if (locale.contains("fr")) {
    DataCacheManager.language = French();
  } else {
    DataCacheManager.language = Languages();
  }

}

class Languages {
  var scan = "Scan";
  var create = "Create";
  var history = "History";
  var settings = "Settings";
  var signInWithGoogle = "Sign in with Google";
  var lastSyncAt = "Last sync at:";
  var qrNRF = "No QR history found.";
  var qrNRFRes = "No QR found.";
  var syncToCloud = "Sync to Cloud";
  var delete = "Delete";
  var entryDelete = "Entry Deleted";
  var cancel = "Cancel";
  var enterValue = "Enter Value";
  var createQR = "Create QR Code";
  var share = "Share";
  var shareSubject1 = "Please find attached my QR Code";
  var shareSubject2 = "Content";
  var scanResult = "Scanner Result";
  var ctClip = "Copied to clipboard";
  var noPermission = "no Permission";
  var selectPrimaryColor = "Select Primary Color";
  var vibration = "Vibration";
  var on = "ON";
  var releaseDate = "Release Date";
  var off = "OFF";
  var sound = "Sound";
  var about = "about";
  var applicationVerison = "Application Version";
  var buildNo = "Build No";
  var selectColor = "Select color";
  var apply = "Apply";
  var logout = "Log Out";
  var internetWarning = "Please connect internet before syncing.";
  var signingIn = "Signing in...";
  var loggingOut = "Logging out...";
  var signingWarning = "Please sign in to sync data in settings.";
  var syncingData = "Syncing Data...";

}

class Spanish extends Languages{
  Spanish(){
    super.scan = "Escanear";
    super.create = "Crear";
    super.history = "historia";
    super.settings = "Configuración";
    super.signInWithGoogle = "Iniciar sesión con Google";
    super.lastSyncAt = "Última sincronización en:";
    super.qrNRF = "No se ha encontrado ningún historial de QR.";
    super.qrNRFRes = "No se encontró qr.";
    super.syncToCloud = "Sincronización con la nube";
    super.delete = "Borrar";
    super.entryDelete = "Entrada eliminada";
    super.cancel = "Cancelar";
    super.enterValue = "Introduzca el valor";
    super.createQR = "Crear código QR";
    super.share = "Compartir";
    super.shareSubject1 = "Por favor, encuentre adjunto mi código QR";
    super.shareSubject2 = "Contenido";
    super.scanResult = "Resultado del escáner";
    super.ctClip = "Copiado en el portapapeles";
    super.noPermission = "sin permiso";
    super.selectPrimaryColor = "Seleccione el color primario";
    super.vibration = "Vibración";
    super.on = "EN";
    super.releaseDate = "Fecha de lanzamiento";
    super.off = "APAGADO";
    super.sound = "Sonido";
    super.about = "acerca de";
    super.applicationVerison = "Versión de la aplicación";
    super.buildNo = "Construir No";
    super.selectColor = "Select color";
    super.apply = "Seleccionar color";
    super.logout = "Cerrar sesión";
    super.internetWarning = "Conecte Internet antes de sincronizar.";
    super.signingIn = "Iniciar sesión...";
    super.loggingOut = "Cerrar sesión...";
    super.signingWarning = "Inicie sesión para sincronizar los datos en la configuración.";
    super.syncingData = "Sincronización de datos...";
  }


}

class French extends Languages {
  French() {
    super.scan = "Numériser";
    super.create = "Créer";
    super.history = "Histoire";
    super.settings = "Paramètres";
    super.signInWithGoogle = "Connectez-vous avec Google";
    super.lastSyncAt = "Dernière synchronisation à :";
    super.qrNRF = "Aucun historique QR trouvé.";
    super.qrNRFRes = "Aucun QR trouvé.";
    super.syncToCloud = "Synchronisation avec le cloud";
    super.delete = "Supprimer";
    super.entryDelete = "Entrée supprimée";
    super.cancel = "Annuler";
    super.enterValue = "Entrez la valeur";
    super.createQR = "Créer un code QR";
    super.share = "Partager";
    super.shareSubject1 = "S’il vous plaît trouver ci-joint mon QR Code";
    super.shareSubject2 = "Contenu";
    super.scanResult = "Résultat de l’analyseur";
    super.ctClip = "Copié dans le Presse-papiers";
    super.noPermission = "pas d’autorisation";
    super.selectPrimaryColor = "Sélectionnez la couleur primaire";
    super.vibration = "Vibration";
    super.on = "SUR";
    super.releaseDate = "Date de sortie";
    super.off = "DE";
    super.sound = "Son";
    super.about = "environ";
    super.applicationVerison = "Version de l’application";
    super.buildNo = "N° de build";
    super.selectColor = "Sélectionner la couleur";
    super.apply = "Appliquer";
    super.logout = "Déconnexion";
    super.internetWarning = "Veuillez vous connecter à Internet avant de synchroniser.";
    super.signingIn = "Se connecter...";
    super.loggingOut = "Déconnexion...";
    super.signingWarning = "Veuillez vous connecter pour synchroniser les données dans les paramètres.";
    super.syncingData = "Synchronisation des données...";
  }
}