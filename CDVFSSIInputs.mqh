//+------------------------------------------------------------------+
//|                                                CDVFSSIInputs.mqh |
//|                                                  Denis Kislitsyn |
//|                                             https://kislitsyn.me |
//+------------------------------------------------------------------+

// Field naming convention:
//  1. With the prefix '__' the field will not be declared for user input
//  2. With the prefix '_' the field will be declared as 'sinput'
//  3. otherwise it will be declared as 'input'

#include "Include\DKStdLib\Common\DKStdLib.mqh"

enum ENUM_SETUP_TYPE {
  SETUP_TYPE_NONE,       // Нет торговли
  SETUP_TYPE_SINGLE,     // Индивидуальный (ПН-ВТ в ТЗ)
  SETUP_TYPE_COMBINED,   // Комбинированный (СР-ПТ в ТЗ)
};

// PARSING AREA OF INPUT STRUCTURE == START == DO NOT REMOVE THIS COMMENT
struct CDVFSSIBotInputs {
  // input  group                    "1. GLOBAL (GLB)"


  // input  group                    "2. SETUP (SET)"
  ENUM_SETUP_TYPE              SET_MON_TYP;             // SET_MON_TYP: Тип сетапа ПН // SETUP_TYPE_COMBINED
  ENUM_SETUP_TYPE              SET_TUE_TYP;             // SET_TUE_TYP: Тип сетапа ВТ // SETUP_TYPE_COMBINED
  ENUM_SETUP_TYPE              SET_WED_TYP;             // SET_WED_TYP: Тип сетапа СР // SETUP_TYPE_SINGLE
  ENUM_SETUP_TYPE              SET_THU_TYP;             // SET_THU_TYP: Тип сетапа ЧТ // SETUP_TYPE_SINGLE
  ENUM_SETUP_TYPE              SET_FRI_TYP;             // SET_FRI_TYP: Тип сетапа ПТ // SETUP_TYPE_SINGLE
  ENUM_SETUP_TYPE              SET_SAT_TYP;             // SET_SAT_TYP: Тип сетапа СБ // SETUP_TYPE_NONE
  ENUM_SETUP_TYPE              SET_SUN_TYP;             // SET_SUN_TYP: Тип сетапа ВС // SETUP_TYPE_NONE
  
  ENUM_SETUP_TYPE              SET_MON_SYM;             // SET_MON_SYM: Список символов для ПН (';'-разд.) // "GBPUSD;EURUSD"
  ENUM_SETUP_SYME              SET_TUE_SYM;             // SET_TUE_SYM: Список символов для ВТ (';'-разд.) // "GBPUSD;EURUSD"
  ENUM_SETUP_SYME              SET_WED_SYM;             // SET_WED_SYM: Список символов для СР (';'-разд.) // "GBPUSD;EURUSD"
  ENUM_SETUP_SYME              SET_THU_SYM;             // SET_THU_SYM: Список символов для ЧТ (';'-разд.) // "EURUSD,GBPUSD;AUDUSD;NZDUSD;USDCAD;USDJPY;USDCHF"
  ENUM_SETUP_SYME              SET_FRI_SYM;             // SET_FRI_SYM: Список символов для ПТ (';'-разд.) // "GBPUSD;EURUSD"
  ENUM_SETUP_SYME              SET_SAT_SYM;             // SET_SAT_SYM: Список символов для СБ (';'-разд.) // ""
  ENUM_SETUP_SYME              SET_SUN_SYM;             // SET_SUN_SYM: Список символов для ВС (';'-разд.) // ""


  
  // input  group                    "5. ГРАФИКА (GUI)"
  bool                        _GUI_ENB;                 // GUI_ENB: Графика включена // true
    
  // input  group                    "6. РАЗНОЕ (MS)"
  ulong                       _MS_MGC;                  // MS_MGC: Expert Adviser ID - Magic // 20250128
  string                      _MS_EGP;                  // MS_EGP: Expert Adviser Global Prefix // "DVFSSI"
  LogLevel                    _MS_LOG_LL;               // MS_LOG_LL: Log Level // INFO
  string                      _MS_LOG_FI;               // MS_LOG_FI: Log Filter IN String (use `;` as sep) // ""
  string                      _MS_LOG_FO;               // MS_LOG_FO: Log Filter OUT String (use `;` as sep) // ""
  bool                        _MS_COM_EN;               // MS_COM_EN: Comment Enable (turn off for fast testing) // true
  uint                        _MS_COM_IS;               // MS_COM_IS: Comment Interval, Sec // 30
  bool                        _MS_COM_CW;               // MS_COM_EW: Comment Custom Window // true
  uint                        _MS_TIM_MS;               // MS_TIM_MS: Timer Interval, ms // 30000
  uint                        __MS_LIC_DUR_SEC;         // MS_LIC_DUR_SEC: License Duration, Sec // 10*24*60*60
  
  
// PARSING AREA OF INPUT STRUCTURE == END == DO NOT REMOVE THIS COMMENT

  string LastErrorMessage;
  bool CDVFSSIBotInputs::InitAndCheck();
  bool CDVFSSIBotInputs::Init();
  bool CDVFSSIBotInputs::CheckBeforeInit();
  bool CDVFSSIBotInputs::CheckAfterInit();
  void CDVFSSIBotInputs::CDVFSSIBotInputs();
  
  
  // IND HNDLs
};

//+------------------------------------------------------------------+
//| Init struc and Check values
//+------------------------------------------------------------------+
bool CDVFSSIBotInputs::InitAndCheck(){
  LastErrorMessage = "";

  if (!CheckBeforeInit())
    return false;

  if (!Init()) {
    LastErrorMessage = "Input.Init() failed";
    return false;
  }

  return CheckAfterInit();
}

//+------------------------------------------------------------------+
//| Init struc
//+------------------------------------------------------------------+
bool CDVFSSIBotInputs::Init(){
  return true;
}

//+------------------------------------------------------------------+
//| Check struc after Init
//+------------------------------------------------------------------+
bool CDVFSSIBotInputs::CheckAfterInit(){
  LastErrorMessage = "";

  return LastErrorMessage == "";
}

// GENERATED CODE == START == DO NOT REMOVE THIS COMMENT

input  group                    "1. GLOBAL (GLB)"


                                                                     // input  group                    "2. SETUP (SET)"
input  ENUM_SETUP_TYPE           Inp_SET_MON_TYP                    = SETUP_TYPE_COMBINED;                                // SET_MON_TYP: Тип сетапа ПН
input  ENUM_SETUP_TYPE           Inp_SET_TUE_TYP                    = SETUP_TYPE_COMBINED;                                // SET_TUE_TYP: Тип сетапа ВТ
input  ENUM_SETUP_TYPE           Inp_SET_WED_TYP                    = SETUP_TYPE_SINGLE;                                  // SET_WED_TYP: Тип сетапа СР
input  ENUM_SETUP_TYPE           Inp_SET_THU_TYP                    = SETUP_TYPE_SINGLE;                                  // SET_THU_TYP: Тип сетапа ЧТ
input  ENUM_SETUP_TYPE           Inp_SET_FRI_TYP                    = SETUP_TYPE_SINGLE;                                  // SET_FRI_TYP: Тип сетапа ПТ
input  ENUM_SETUP_TYPE           Inp_SET_SAT_TYP                    = SETUP_TYPE_NONE;                                    // SET_SAT_TYP: Тип сетапа СБ
input  ENUM_SETUP_TYPE           Inp_SET_SUN_TYP                    = SETUP_TYPE_NONE;                                    // SET_SUN_TYP: Тип сетапа ВС
input  ENUM_SETUP_TYPE           Inp_SET_MON_SYM                    = "GBPUSD;EURUSD";                                    // SET_MON_SYM: Список символов для ПН (';'-разд.)
input  ENUM_SETUP_SYME           Inp_SET_TUE_SYM                    = "GBPUSD;EURUSD";                                    // SET_TUE_SYM: Список символов для ВТ (';'-разд.)
input  ENUM_SETUP_SYME           Inp_SET_WED_SYM                    = "GBPUSD;EURUSD";                                    // SET_WED_SYM: Список символов для СР (';'-разд.)
input  ENUM_SETUP_SYME           Inp_SET_THU_SYM                    = "EURUSD,GBPUSD;AUDUSD;NZDUSD;USDCAD;USDJPY;USDCHF"; // SET_THU_SYM: Список символов для ЧТ (';'-разд.)
input  ENUM_SETUP_SYME           Inp_SET_FRI_SYM                    = "GBPUSD;EURUSD";                                    // SET_FRI_SYM: Список символов для ПТ (';'-разд.)
input  ENUM_SETUP_SYME           Inp_SET_SAT_SYM                    = "";                                                 // SET_SAT_SYM: Список символов для СБ (';'-разд.)
input  ENUM_SETUP_SYME           Inp_SET_SUN_SYM                    = "";                                                 // SET_SUN_SYM: Список символов для ВС (';'-разд.)

input  group                    "5. ГРАФИКА (GUI)"
sinput bool                      Inp__GUI_ENB                       = true;                                               // GUI_ENB: Графика включена

input  group                    "6. РАЗНОЕ (MS)"
sinput ulong                     Inp__MS_MGC                        = 20250128;                                           // MS_MGC: Expert Adviser ID - Magic
sinput string                    Inp__MS_EGP                        = "DVFSSI";                                           // MS_EGP: Expert Adviser Global Prefix
sinput LogLevel                  Inp__MS_LOG_LL                     = INFO;                                               // MS_LOG_LL: Log Level
sinput string                    Inp__MS_LOG_FI                     = "";                                                 // MS_LOG_FI: Log Filter IN String (use `;` as sep)
sinput string                    Inp__MS_LOG_FO                     = "";                                                 // MS_LOG_FO: Log Filter OUT String (use `;` as sep)
sinput bool                      Inp__MS_COM_EN                     = true;                                               // MS_COM_EN: Comment Enable (turn off for fast testing)
sinput uint                      Inp__MS_COM_IS                     = 30;                                                 // MS_COM_IS: Comment Interval, Sec
sinput bool                      Inp__MS_COM_CW                     = true;                                               // MS_COM_EW: Comment Custom Window
sinput uint                      Inp__MS_TIM_MS                     = 30000;                                              // MS_TIM_MS: Timer Interval, ms


//+------------------------------------------------------------------+
//| Fill Input struc with user inputs vars
//+------------------------------------------------------------------+    
void FillInputs(CDVFSSIBotInputs& _inputs) {
  _inputs.SET_MON_TYP               = Inp_SET_MON_TYP;                                                                    // SET_MON_TYP: Тип сетапа ПН
  _inputs.SET_TUE_TYP               = Inp_SET_TUE_TYP;                                                                    // SET_TUE_TYP: Тип сетапа ВТ
  _inputs.SET_WED_TYP               = Inp_SET_WED_TYP;                                                                    // SET_WED_TYP: Тип сетапа СР
  _inputs.SET_THU_TYP               = Inp_SET_THU_TYP;                                                                    // SET_THU_TYP: Тип сетапа ЧТ
  _inputs.SET_FRI_TYP               = Inp_SET_FRI_TYP;                                                                    // SET_FRI_TYP: Тип сетапа ПТ
  _inputs.SET_SAT_TYP               = Inp_SET_SAT_TYP;                                                                    // SET_SAT_TYP: Тип сетапа СБ
  _inputs.SET_SUN_TYP               = Inp_SET_SUN_TYP;                                                                    // SET_SUN_TYP: Тип сетапа ВС
  _inputs.SET_MON_SYM               = Inp_SET_MON_SYM;                                                                    // SET_MON_SYM: Список символов для ПН (';'-разд.)
  _inputs.SET_TUE_SYM               = Inp_SET_TUE_SYM;                                                                    // SET_TUE_SYM: Список символов для ВТ (';'-разд.)
  _inputs.SET_WED_SYM               = Inp_SET_WED_SYM;                                                                    // SET_WED_SYM: Список символов для СР (';'-разд.)
  _inputs.SET_THU_SYM               = Inp_SET_THU_SYM;                                                                    // SET_THU_SYM: Список символов для ЧТ (';'-разд.)
  _inputs.SET_FRI_SYM               = Inp_SET_FRI_SYM;                                                                    // SET_FRI_SYM: Список символов для ПТ (';'-разд.)
  _inputs.SET_SAT_SYM               = Inp_SET_SAT_SYM;                                                                    // SET_SAT_SYM: Список символов для СБ (';'-разд.)
  _inputs.SET_SUN_SYM               = Inp_SET_SUN_SYM;                                                                    // SET_SUN_SYM: Список символов для ВС (';'-разд.)
  _inputs._GUI_ENB                  = Inp__GUI_ENB;                                                                       // GUI_ENB: Графика включена
  _inputs._MS_MGC                   = Inp__MS_MGC;                                                                        // MS_MGC: Expert Adviser ID - Magic
  _inputs._MS_EGP                   = Inp__MS_EGP;                                                                        // MS_EGP: Expert Adviser Global Prefix
  _inputs._MS_LOG_LL                = Inp__MS_LOG_LL;                                                                     // MS_LOG_LL: Log Level
  _inputs._MS_LOG_FI                = Inp__MS_LOG_FI;                                                                     // MS_LOG_FI: Log Filter IN String (use `;` as sep)
  _inputs._MS_LOG_FO                = Inp__MS_LOG_FO;                                                                     // MS_LOG_FO: Log Filter OUT String (use `;` as sep)
  _inputs._MS_COM_EN                = Inp__MS_COM_EN;                                                                     // MS_COM_EN: Comment Enable (turn off for fast testing)
  _inputs._MS_COM_IS                = Inp__MS_COM_IS;                                                                     // MS_COM_IS: Comment Interval, Sec
  _inputs._MS_COM_CW                = Inp__MS_COM_CW;                                                                     // MS_COM_EW: Comment Custom Window
  _inputs._MS_TIM_MS                = Inp__MS_TIM_MS;                                                                     // MS_TIM_MS: Timer Interval, ms
}


//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+
void CDVFSSIBotInputs::CDVFSSIBotInputs():
       SET_MON_TYP(SETUP_TYPE_COMBINED),
       SET_TUE_TYP(SETUP_TYPE_COMBINED),
       SET_WED_TYP(SETUP_TYPE_SINGLE),
       SET_THU_TYP(SETUP_TYPE_SINGLE),
       SET_FRI_TYP(SETUP_TYPE_SINGLE),
       SET_SAT_TYP(SETUP_TYPE_NONE),
       SET_SUN_TYP(SETUP_TYPE_NONE),
       SET_MON_SYM("GBPUSD;EURUSD"),
       SET_TUE_SYM("GBPUSD;EURUSD"),
       SET_WED_SYM("GBPUSD;EURUSD"),
       SET_THU_SYM("EURUSD,GBPUSD;AUDUSD;NZDUSD;USDCAD;USDJPY;USDCHF"),
       SET_FRI_SYM("GBPUSD;EURUSD"),
       SET_SAT_SYM(""),
       SET_SUN_SYM(""),
       _GUI_ENB(true),
       _MS_MGC(20250128),
       _MS_EGP("DVFSSI"),
       _MS_LOG_LL(INFO),
       _MS_LOG_FI(""),
       _MS_LOG_FO(""),
       _MS_COM_EN(true),
       _MS_COM_IS(30),
       _MS_COM_CW(true),
       _MS_TIM_MS(30000),
       __MS_LIC_DUR_SEC(10*24*60*60){

};


//+------------------------------------------------------------------+
//| Check struc before Init
//+------------------------------------------------------------------+
bool CDVFSSIBotInputs::CheckBeforeInit() {
  LastErrorMessage = "";


  return LastErrorMessage == "";
}
// GENERATED CODE == END == DO NOT REMOVE THIS COMMENT



