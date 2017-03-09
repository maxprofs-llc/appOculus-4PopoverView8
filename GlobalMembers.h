//
//  GlobalMembers.h
//  IsaíApp
//
//  Created by Isaí G. on 02/10/13.
//  Copyright © 2013 Isai Garcia Reyes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "Enums.h"
#import "InternetServices.h"


#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface GlobalMembers : NSObject

extern NSString *idFotoImprimir;
extern NSString *variable2;

#pragma mark URL SERVICIOS -
/*Registro del dispositivo para PUSH NOTIFICATIONS*/
extern NSString *URLRegisterDevicePN;
extern NSString *URLUNRegisterDevicePN;

#pragma mark VARIABLES GLOBALES-
/**
 * Lista de dispositivos encontrados en Locator
 */
extern NSMutableArray *mDeviceUserList;

/**
 * Lista de vehiculos dependiento del vehiculo seleccionado
 */
extern NSMutableArray *actionsUserArrayShared;

/**
 * Lista de los nombre de los dispositivos con el que se puede emparejar el
 * Dispositivo
 */
extern NSString *nameDevice;
extern NSString *nameAuto;
extern NSString *lastDeviceAlerted;

//DOWNLOADING TASK
extern BOOL IS_DOWNLOADINGMAP;
extern BOOL IS_DOWNLOADINGCANCELLED;

/**
 * Esta es usada como bandera para ejecutar codigo de prueba en modo Debug,
 * ES IMPORTANTE PONERLA EN FALSE AL CREAR EL PAQUETE
 */
extern bool debugs;
extern bool changeLanguage;
extern bool StartAplication;


///numero de emergencia
extern NSString *numEmergencia;
extern int lenghtNumCel;

///brandSelected
extern NSString *brandName;
extern NSString *nameStoryBoard;

//////// Para saber la orientacion del dispositivo //////
extern  UIDeviceOrientation devOrientation;

////Saber el tamaño del screen/////
extern CGSize screenSize;

extern NSString *mapTTLenguage;
extern NSString *languageSelected;
extern NSString *countrySelected;
extern NSString *countryName;
extern NSString *cityName;
extern NSString *devicePhoneNumber;
extern BOOL emailNotif;
extern BOOL pushNotif;
extern NSString *uuidPhone;
extern NSString *tokenPush;
extern NSString *sessionKeyLocator;
extern NSString *userIdLocator;
extern BOOL showMessageLegal;
extern NSString *accountID;
extern NSString *selectedVehicleDeviceId;
extern NSString *usuCuenta;
extern NSString *contraCuenta;

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
extern NSString *Cultures;

/**
 * Formato de fecha
 */
extern NSString *DATE_FORMAT;
/**
 * Formato de hora
 */
extern NSString *TIME_FORMAT;
/**
 * Formato de fecha hora
 */
extern NSString *DATETIME_FORMAT;
/**
 * Formato de fecha con letra
 */
extern NSString *DATELETTER_FORMAT;

#pragma mark  @implementation-

///Arreglo de los coches///
extern NSMutableArray *actionsAuto;
extern NSMutableArray *actionsAutoDown;

//Internet Service Varibles
extern InternetServices *netValidator;
extern BOOL GisInternetAvaliable;
extern int lastNotifSend;
extern int GInternetStatus;
extern int GserviceType;

extern NSString *applicationSourceId;

extern NSDictionary *positionActionAlertData;

//DESCARGA DEL MAPA
extern int mapStatus;

//Logs Flag
extern BOOL applicationLogs;

// USERDEVICESLIST FROM MAINACTIVITY
extern NSArray *userDeviceList;

// version
// Esperando CommandExecute
extern BOOL DoorsUnlockActivate;
extern BOOL DoorsLockActivate;
extern BOOL SpeedActivate;
extern BOOL DisarmActivate;
extern BOOL FindMeActivate;
extern BOOL FollowMeValetActivate;
extern BOOL HornLigthsActivate;
extern BOOL HornActivate;
extern BOOL SpeedAlwaysActivate;
extern BOOL ValetActivate;
extern BOOL ParkingActivate;
extern BOOL SendPNDNavigationCommandActivate;
extern BOOL PIDSActivate;
extern BOOL DTCActivate;
extern BOOL DTCShowView;

extern BOOL DEBUGGIN_FLAG;

// donwload package
extern NSInteger lastPackage;
extern BOOL Calculated;

//TOM TOM
//NAVIGATION
extern bool navigationActive;

/**
 * Contiene el nombre de la Base de datos
 */
extern NSString *nameDatabase;

//PIDS & SCH
extern BOOL PIDSREDORB;
extern BOOL SCHEREDORB;

extern  BOOL SwitchActive;

// VARIABLES IMPRESION



@end
