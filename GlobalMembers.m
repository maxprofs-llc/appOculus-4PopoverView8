//
//  GlobalMembers.m
//  IsaíApp
//
//  Created by Isaí G. on 02/10/13.
//  Copyright © 2013 Isai Garcia Reyes. All rights reserved.
//

#import "GlobalMembers.h"

NSString *idFotoImprimir = @"";
NSString *variable2 = @"";


#pragma mark URL SERVICIOS -
//Registro del dispositivo para PUSH NOTIFICATIONS
//No encriptado
//NSString *URLRegisterDevicePN = @"https://servicesdv.irtbr.com/pushnotification/servicelayer/deviceRegister.ashx"; //@"http://189.125.103.26/pushnotification/ServiceLayer/DeviceRegister.ashx";

//Encriptado
NSString *URLRegisterDevicePN = @"https://servicesar.irtbr.com/PushNotificationEncrypt/ServiceLayer/DeviceRegister.ashx";

NSString *URLUNRegisterDevicePN = @"http://servicesdv.irtbr.com/pushnotification/ServiceLayer/UnRegister.ashx";

#pragma mark VARIABLES GLOBALES-
/**
 * Lista de dispositivos encontrados en Locator
 */
NSMutableArray *mDeviceUserList;

/**
 * Lista de vehiculos dependiento del vehiculo seleccionado
 */
NSMutableArray *actionsUserArrayShared;

/**
 * Lista de los nombre de los dispositivos con el que se puede emparejar el
 * Dispositivo
 */
NSString *nameDevice = @"";
NSString *nameAuto=@"";
NSString *lastDeviceAlerted=@"";

//DOWNLOADING TASK
BOOL IS_DOWNLOADINGMAP = NO ;
BOOL IS_DOWNLOADINGCANCELLED = NO ;


/**
 * Esta es usada como bandera para ejecutar codigo de prueba en modo Debug,
 * ES IMPORTANTE PONERLA EN FALSE AL CREAR EL PAQUETE
 */
bool debugs = true;
bool changeLanguage = false;
bool StartAplication = true;

///numero de emergencia
NSString *numEmergencia = @"08007366827";
int lenghtNumCel=12;

///brandSelected
NSString *brandName;
NSString *nameStoryBoard;

//////// Para saber la orientacion del dispositivo //////
UIDeviceOrientation devOrientation;

////Saber el tamaño del screen/////
CGSize screenSize;

NSString *languageSelected;
NSString *countrySelected;
NSString *countryName;
NSString *cityName;
NSString *devicePhoneNumber;
BOOL emailNotif;
BOOL pushNotif;
NSString *uuidPhone;
NSString *tokenPush;
NSString *sessionKeyLocator;
NSString *userIdLocator;
NSString *accountID;
BOOL showMessageLegal;
NSString *selectedVehicleDeviceId;
NSString *usuCuenta;
NSString *contraCuenta;

#pragma mark -
/**
 * Lenguajes soportados por la aplicacion:<br>
 * <br>
 * <b>Default=def (Toma el que esta en el dispositivo)<br>
 * EspaÃ±ol=es<br>
 * Ingles/South Africa=en<br>
 * Ruso=ru<br>
 * Chino=zh-CHT</b>
 */
NSString *Cultures = @"es";

/**
 * Formato de fecha
 */
NSString *DATE_FORMAT = @"dd/MM/yyyy";
/**
 * Formato de hora
 */
NSString *TIME_FORMAT = @"HH:mm";
/**
 * Formato de fecha hora
 */
NSString *DATETIME_FORMAT = @"dd/MM/yyyy HH:mm";
/**
 * Formato de fecha con letra
 */
NSString *DATELETTER_FORMAT = @"EEEE dd MMMM yyyy";


#pragma mark  @implementation-
@implementation GlobalMembers

///Arreglo de los coches///
NSMutableArray *actionsAuto;
NSMutableArray *actionsAutoDown;

/// Internet connection class //
InternetServices *netValidator;
BOOL GisInternetAvaliable;
int lastNotifSend;
int GInternetStatus;
int GserviceType;

NSString *applicationSourceId = @"12";

NSDictionary *positionActionAlertData;

//DESCARGA DEL MAPA
int mapStatus = 0;

//Logs Flag
BOOL applicationLogs = NO;

// USERDEVICESLIST FROM MAINACTIVITY
NSArray *userDeviceList;

// version
// Esperando CommandExecute
BOOL DoorsUnlockActivate;
BOOL DoorsLockActivate;

BOOL DEBUGGIN_FLAG = YES;


NSInteger lastPackage;
BOOL Calculated;


bool navigationActive = NO;

/**
 * Contiene el nombre de la Base de datos
 */
NSString *nameDatabase;

//PIDS & SCH
BOOL PIDSREDORB = NO;
BOOL SCHEREDORB = NO;

BOOL SwitchActive = NO;

@end

