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

enum ENUM_OPEN_POS_RETCODE {
  SUCCESS                               = 0,
  
  FILTERED_ORDER_IN_MARKET              = 10,  
  FILTERED_POS_IN_MARKET                = 11,  
  FILTERED_NEWS_TIME                    = 12,  
  FILTERED_NEWS_HUGE_BAR                = 13,  
  NO_SIGNAL                             = 20,
  TRADE_ERROR                           = 30,
};

enum ENUM_SETUP_TYPE {
  NONE,       // Нет торговли
  SINGLE,     // Индивидуальный (СР-ПТ в ТЗ)
  COMBINED,   // Комбинированный (ПН-ВТ в ТЗ)
};

enum ENUM_BOT_MODE {
  EXPORT_NEWS_TO_FILE, // Экспорт новостей в файл
  TRADING,             // Торговля
};

enum ENUM_TP_TYPE {
  FIXED_PNT,           // Фиксированное расстояние в пунктах
  FIXED_RR,            // Фиксированный Risk Reward
  OPPOSITE_SLC,        // Противоположенный SLC
};

// PARSING AREA OF INPUT STRUCTURE == START == DO NOT REMOVE THIS COMMENT
struct CDVFSSIBotInputs {
  // input  group                    "1. ГЛОБАЛЬНЫЕ (GLB)"
  ENUM_BOT_MODE               GLB_BOT_MODE;             // GLB_BOT_MODE: Режим работы // TRADING
  uint                        GLB_SLC_DPT;              // GLB_SLC_DPT: Глубина поиска уровней SLC, баров // 100(x>0)


  // input  group                    "2. СЕТАПЫ (SET)"
  ENUM_SETUP_TYPE             SET_TYP_MON;              // SET_TYP_MON: Тип сетапа ПН // COMBINED
  ENUM_SETUP_TYPE             SET_TYP_TUE;              // SET_TYP_TUE: Тип сетапа ВТ // COMBINED
  ENUM_SETUP_TYPE             SET_TYP_WED;              // SET_TYP_WED: Тип сетапа СР // COMBINED
  ENUM_SETUP_TYPE             SET_TYP_THU;              // SET_TYP_THU: Тип сетапа ЧТ // COMBINED
  ENUM_SETUP_TYPE             SET_TYP_FRI;              // SET_TYP_FRI: Тип сетапа ПТ // COMBINED
  ENUM_SETUP_TYPE             SET_TYP_SAT;              // SET_TYP_SAT: Тип сетапа СБ // NONE
  ENUM_SETUP_TYPE             SET_TYP_SUN;              // SET_TYP_SUN: Тип сетапа ВС // NONE
  
  string                      SET_SYM_MON;              // SET_SYM_MON: Список символов для ПН (';'-разд.) // "GBPUSD;EURUSD"
  string                      SET_SYM_TUE;              // SET_SYM_TUE: Список символов для ВТ (';'-разд.) // "GBPUSD;EURUSD"
  string                      SET_SYM_WED;              // SET_SYM_WED: Список символов для СР (';'-разд.) // "GBPUSD;EURUSD"
  string                      SET_SYM_THU;              // SET_SYM_THU: Список символов для ЧТ (';'-разд.) // "GBPUSD;EURUSD"
  string                      SET_SYM_FRI;              // SET_SYM_FRI: Список символов для ПТ (';'-разд.) // "GBPUSD;EURUSD"
  string                      SET_SYM_SAT;              // SET_SYM_SAT: Список символов для СБ (';'-разд.) // ""
  string                      SET_SYM_SUN;              // SET_SYM_SUN: Список символов для ВС (';'-разд.) // ""

  // input  group                    "3. ФИЛЬТРЫ (FIL)"
  string                      FIL_TIM_MON;              // FIL_TIM_MON: Разрешенный период торговли в ПН (HH:MM-HH:MM) // "09:00-22:00"
  string                      FIL_TIM_TUE;              // FIL_TIM_MON: Разрешенный период торговли в ВТ (HH:MM-HH:MM) // "09:00-22:00"
  string                      FIL_TIM_WED;              // FIL_TIM_MON: Разрешенный период торговли в СР (HH:MM-HH:MM) // "09:00-22:00"
  string                      FIL_TIM_THU;              // FIL_TIM_MON: Разрешенный период торговли в ЧТ (HH:MM-HH:MM) // "09:00-22:00"
  string                      FIL_TIM_FRI;              // FIL_TIM_MON: Разрешенный период торговли в ПТ (HH:MM-HH:MM) // "09:00-18:00"
  string                      FIL_TIM_SAT;              // FIL_TIM_MON: Разрешенный период торговли в СБ (HH:MM-HH:MM) // ""
  string                      FIL_TIM_SUN;              // FIL_TIM_MON: Разрешенный период торговли в ВС (HH:MM-HH:MM) // ""
  
  bool                        FIL_NWS_ENB;              // FIL_NWS_ENB: Включить фильтрацию вокруг новостей // true
  string                      FIL_NWS_NAM;              // FIL_NWS_NAM: Список имен новостей (';'-разд.) // ""
  bool                        FIL_NWS_NIF;              // FIL_NWS_NIF: Загрузить имена новостей из файла 'dvfssi_news.txt' // true
  int                         FIL_NWS_BMN;              // FIL_NWS_BMN: Время до новостей, мин // -60
  int                         FIL_NWS_AMN;              // FIL_NWS_AMN: Время после новостей, мин // 120
  ENUM_TIMEFRAMES             FIL_NWS_STF;              // FIL_NWS_STF: TF свечи после новости для откл. торговли // PERIOD_H1
  uint                        FIL_NWS_SBS;              // FIL_NWS_SBS: Max свеча после новости для откл. торговли, пункт // 60
  
  uint                        FIL_TP_MIN;               // FIL_TP_MIN: Мин допустимый TP, пункт // 30
    
  // input  group                    "4. ВХОДЫ (ENT)"
  ENUM_MM_TYPE                ENT_MM_TYP;               // ENT_MM_TYP: Тип лота // ENUM_MM_TYPE_BALANCE_PERCENT
  double                      ENT_MM_VAL;               // ENT_MM_VAL: Значение для расчета лота // 0.5(x > 0)
  uint                        ENT_PO_SHT;               // ENT_PO_SHT: Сдвиг EP отложенного ордера от EP, пункт (0-откл) // 15
  uint                        ENT_PO_EXP;               // ENT_PO_EXP: Срок истечения отложенного ордера, сек (0-откл) // 2*60*60
  uint                        ENT_SL_PNT;               // ENT_SL_PNT: Фиксированный SL, пункт // 15(x > 0)
  ENUM_TP_TYPE                ENT_TP_TYP;               // ENT_TP_TYP: Тип TP // FIXED_PNT
  uint                        ENT_TP_PNT;               // ENT_TP_PNT: Фиксированный TP, пункт // 30(x > 0)
  double                      ENT_TP_RR;                // ENT_TP_RR: TP RR // 2.0(x > 0)

  // input  group                    "5. ОПОВЕЩЕНИЯ (NOT)"
  bool                        _NOT_ALR_ENB;             // NOT_ALR_ENB: Включить оповещения в терминале // true
  bool                        _NOT_PUS_ENB;             // NOT_PUS_ENB: Включить мобильные push уведомления // true
  
  // input  group                    "6. ГРАФИКА (GUI)"
  bool                        _GUI_ENB;                 // GUI_ENB: Графика включена // true  
    
  // input  group                    "7. РАЗНОЕ (MS)"
  ulong                       _MS_MGC;                  // MS_MGC: Expert Adviser ID - Magic // 20250203
  string                      _MS_EGP;                  // MS_EGP: Expert Adviser Global Prefix // "DVFSSI"
  LogLevel                    _MS_LOG_LL;               // MS_LOG_LL: Log Level // INFO
  string                      _MS_LOG_FI;               // MS_LOG_FI: Log Filter IN String (use `;` as sep) // ""
  string                      _MS_LOG_FO;               // MS_LOG_FO: Log Filter OUT String (use `;` as sep) // ""
  bool                        _MS_COM_EN;               // MS_COM_EN: Comment Enable (turn off for fast testing) // true
  uint                        _MS_COM_IS;               // MS_COM_IS: Comment Interval, Sec // 30
  bool                        _MS_COM_CW;               // MS_COM_EW: Comment Custom Window // true
  uint                        _MS_TIM_MS;               // MS_TIM_MS: Timer Interval, ms // 30000
  uint                        __MS_NWS_DEL;             // __MS_NWS_DEL: Частота обновления новостей из календаря, дн // 10
  uint                        __MS_LIC_DUR_SEC;         // MS_LIC_DUR_SEC: License Duration, Sec // 0*24*60*60
  
  string                      _MS_MOC_SYM_1;            // _MS_MOC_SYM_1: Mock Levels for Symbol #1 (''-off) // ""
  double                      _MS_MOC_LNG_1;            // _MS_MOC_LNG_1: Mock Long Level for Symbol #1 // 0
  double                      _MS_MOC_SHT_1;            // _MS_MOC_SHT_1: Mock Short Level for Symbol #1 // 0

  string                      _MS_MOC_SYM_2;            // _MS_MOC_SYM_2: Mock Levels for Symbol #2 (''-off) // ""
  double                      _MS_MOC_LNG_2;            // _MS_MOC_LNG_2: Mock Long Level for Symbol #2 // 0
  double                      _MS_MOC_SHT_2;            // _MS_MOC_SHT_2: Mock Short Level for Symbol #2 // 0
  
  
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

input  group                    "1. ГЛОБАЛЬНЫЕ (GLB)"
input  ENUM_BOT_MODE             Inp_GLB_BOT_MODE                   = TRADING;                      // GLB_BOT_MODE: Режим работы
input  uint                      Inp_GLB_SLC_DPT                    = 100;                          // GLB_SLC_DPT: Глубина поиска уровней SLC, баров

input  group                    "2. СЕТАПЫ (SET)"
input  ENUM_SETUP_TYPE           Inp_SET_TYP_MON                    = COMBINED;                     // SET_TYP_MON: Тип сетапа ПН
input  ENUM_SETUP_TYPE           Inp_SET_TYP_TUE                    = COMBINED;                     // SET_TYP_TUE: Тип сетапа ВТ
input  ENUM_SETUP_TYPE           Inp_SET_TYP_WED                    = COMBINED;                     // SET_TYP_WED: Тип сетапа СР
input  ENUM_SETUP_TYPE           Inp_SET_TYP_THU                    = COMBINED;                     // SET_TYP_THU: Тип сетапа ЧТ
input  ENUM_SETUP_TYPE           Inp_SET_TYP_FRI                    = COMBINED;                     // SET_TYP_FRI: Тип сетапа ПТ
input  ENUM_SETUP_TYPE           Inp_SET_TYP_SAT                    = NONE;                         // SET_TYP_SAT: Тип сетапа СБ
input  ENUM_SETUP_TYPE           Inp_SET_TYP_SUN                    = NONE;                         // SET_TYP_SUN: Тип сетапа ВС
input  string                    Inp_SET_SYM_MON                    = "GBPUSD;EURUSD";              // SET_SYM_MON: Список символов для ПН (';'-разд.)
input  string                    Inp_SET_SYM_TUE                    = "GBPUSD;EURUSD";              // SET_SYM_TUE: Список символов для ВТ (';'-разд.)
input  string                    Inp_SET_SYM_WED                    = "GBPUSD;EURUSD";              // SET_SYM_WED: Список символов для СР (';'-разд.)
input  string                    Inp_SET_SYM_THU                    = "GBPUSD;EURUSD";              // SET_SYM_THU: Список символов для ЧТ (';'-разд.)
input  string                    Inp_SET_SYM_FRI                    = "GBPUSD;EURUSD";              // SET_SYM_FRI: Список символов для ПТ (';'-разд.)
input  string                    Inp_SET_SYM_SAT                    = "";                           // SET_SYM_SAT: Список символов для СБ (';'-разд.)
input  string                    Inp_SET_SYM_SUN                    = "";                           // SET_SYM_SUN: Список символов для ВС (';'-разд.)

input  group                    "3. ФИЛЬТРЫ (FIL)"
input  string                    Inp_FIL_TIM_MON                    = "09:00-22:00";                // FIL_TIM_MON: Разрешенный период торговли в ПН (HH:MM-HH:MM)
input  string                    Inp_FIL_TIM_TUE                    = "09:00-22:00";                // FIL_TIM_MON: Разрешенный период торговли в ВТ (HH:MM-HH:MM)
input  string                    Inp_FIL_TIM_WED                    = "09:00-22:00";                // FIL_TIM_MON: Разрешенный период торговли в СР (HH:MM-HH:MM)
input  string                    Inp_FIL_TIM_THU                    = "09:00-22:00";                // FIL_TIM_MON: Разрешенный период торговли в ЧТ (HH:MM-HH:MM)
input  string                    Inp_FIL_TIM_FRI                    = "09:00-18:00";                // FIL_TIM_MON: Разрешенный период торговли в ПТ (HH:MM-HH:MM)
input  string                    Inp_FIL_TIM_SAT                    = "";                           // FIL_TIM_MON: Разрешенный период торговли в СБ (HH:MM-HH:MM)
input  string                    Inp_FIL_TIM_SUN                    = "";                           // FIL_TIM_MON: Разрешенный период торговли в ВС (HH:MM-HH:MM)
input  bool                      Inp_FIL_NWS_ENB                    = true;                         // FIL_NWS_ENB: Включить фильтрацию вокруг новостей
input  string                    Inp_FIL_NWS_NAM                    = "";                           // FIL_NWS_NAM: Список имен новостей (';'-разд.)
input  bool                      Inp_FIL_NWS_NIF                    = true;                         // FIL_NWS_NIF: Загрузить имена новостей из файла 'dvfssi_news.txt'
input  int                       Inp_FIL_NWS_BMN                    = -60;                          // FIL_NWS_BMN: Время до новостей, мин
input  int                       Inp_FIL_NWS_AMN                    = 120;                          // FIL_NWS_AMN: Время после новостей, мин
input  ENUM_TIMEFRAMES           Inp_FIL_NWS_STF                    = PERIOD_H1;                    // FIL_NWS_STF: TF свечи после новости для откл. торговли
input  uint                      Inp_FIL_NWS_SBS                    = 60;                           // FIL_NWS_SBS: Max свеча после новости для откл. торговли, пункт
input  uint                      Inp_FIL_TP_MIN                     = 30;                           // FIL_TP_MIN: Мин допустимый TP, пункт

input  group                    "4. ВХОДЫ (ENT)"
input  ENUM_MM_TYPE              Inp_ENT_MM_TYP                     = ENUM_MM_TYPE_BALANCE_PERCENT; // ENT_MM_TYP: Тип лота
input  double                    Inp_ENT_MM_VAL                     = 0.5;                          // ENT_MM_VAL: Значение для расчета лота
input  uint                      Inp_ENT_PO_SHT                     = 15;                           // ENT_PO_SHT: Сдвиг EP отложенного ордера от EP, пункт (0-откл)
input  uint                      Inp_ENT_PO_EXP                     = 2*60*60;                      // ENT_PO_EXP: Срок истечения отложенного ордера, сек (0-откл)
input  uint                      Inp_ENT_SL_PNT                     = 15;                           // ENT_SL_PNT: Фиксированный SL, пункт
input  ENUM_TP_TYPE              Inp_ENT_TP_TYP                     = FIXED_PNT;                    // ENT_TP_TYP: Тип TP
input  uint                      Inp_ENT_TP_PNT                     = 30;                           // ENT_TP_PNT: Фиксированный TP, пункт
input  double                    Inp_ENT_TP_RR                      = 2.0;                          // ENT_TP_RR: TP RR

input  group                    "5. ОПОВЕЩЕНИЯ (NOT)"
sinput bool                      Inp__NOT_ALR_ENB                   = true;                         // NOT_ALR_ENB: Включить оповещения в терминале
sinput bool                      Inp__NOT_PUS_ENB                   = true;                         // NOT_PUS_ENB: Включить мобильные push уведомления

input  group                    "6. ГРАФИКА (GUI)"
sinput bool                      Inp__GUI_ENB                       = true;                         // GUI_ENB: Графика включена

input  group                    "7. РАЗНОЕ (MS)"
sinput ulong                     Inp__MS_MGC                        = 20250203;                     // MS_MGC: Expert Adviser ID - Magic
sinput string                    Inp__MS_EGP                        = "DVFSSI";                     // MS_EGP: Expert Adviser Global Prefix
sinput LogLevel                  Inp__MS_LOG_LL                     = INFO;                         // MS_LOG_LL: Log Level
sinput string                    Inp__MS_LOG_FI                     = "";                           // MS_LOG_FI: Log Filter IN String (use `;` as sep)
sinput string                    Inp__MS_LOG_FO                     = "";                           // MS_LOG_FO: Log Filter OUT String (use `;` as sep)
sinput bool                      Inp__MS_COM_EN                     = true;                         // MS_COM_EN: Comment Enable (turn off for fast testing)
sinput uint                      Inp__MS_COM_IS                     = 30;                           // MS_COM_IS: Comment Interval, Sec
sinput bool                      Inp__MS_COM_CW                     = true;                         // MS_COM_EW: Comment Custom Window
sinput uint                      Inp__MS_TIM_MS                     = 30000;                        // MS_TIM_MS: Timer Interval, ms
sinput string                    Inp__MS_MOC_SYM_1                  = "";                           // _MS_MOC_SYM_1: Mock Levels for Symbol #1 (''-off)
sinput double                    Inp__MS_MOC_LNG_1                  = 0;                            // _MS_MOC_LNG_1: Mock Long Level for Symbol #1
sinput double                    Inp__MS_MOC_SHT_1                  = 0;                            // _MS_MOC_SHT_1: Mock Short Level for Symbol #1
sinput string                    Inp__MS_MOC_SYM_2                  = "";                           // _MS_MOC_SYM_2: Mock Levels for Symbol #2 (''-off)
sinput double                    Inp__MS_MOC_LNG_2                  = 0;                            // _MS_MOC_LNG_2: Mock Long Level for Symbol #2
sinput double                    Inp__MS_MOC_SHT_2                  = 0;                            // _MS_MOC_SHT_2: Mock Short Level for Symbol #2


//+------------------------------------------------------------------+
//| Fill Input struc with user inputs vars
//+------------------------------------------------------------------+    
void FillInputs(CDVFSSIBotInputs& _inputs) {
  _inputs.GLB_BOT_MODE              = Inp_GLB_BOT_MODE;                                             // GLB_BOT_MODE: Режим работы
  _inputs.GLB_SLC_DPT               = Inp_GLB_SLC_DPT;                                              // GLB_SLC_DPT: Глубина поиска уровней SLC, баров
  _inputs.SET_TYP_MON               = Inp_SET_TYP_MON;                                              // SET_TYP_MON: Тип сетапа ПН
  _inputs.SET_TYP_TUE               = Inp_SET_TYP_TUE;                                              // SET_TYP_TUE: Тип сетапа ВТ
  _inputs.SET_TYP_WED               = Inp_SET_TYP_WED;                                              // SET_TYP_WED: Тип сетапа СР
  _inputs.SET_TYP_THU               = Inp_SET_TYP_THU;                                              // SET_TYP_THU: Тип сетапа ЧТ
  _inputs.SET_TYP_FRI               = Inp_SET_TYP_FRI;                                              // SET_TYP_FRI: Тип сетапа ПТ
  _inputs.SET_TYP_SAT               = Inp_SET_TYP_SAT;                                              // SET_TYP_SAT: Тип сетапа СБ
  _inputs.SET_TYP_SUN               = Inp_SET_TYP_SUN;                                              // SET_TYP_SUN: Тип сетапа ВС
  _inputs.SET_SYM_MON               = Inp_SET_SYM_MON;                                              // SET_SYM_MON: Список символов для ПН (';'-разд.)
  _inputs.SET_SYM_TUE               = Inp_SET_SYM_TUE;                                              // SET_SYM_TUE: Список символов для ВТ (';'-разд.)
  _inputs.SET_SYM_WED               = Inp_SET_SYM_WED;                                              // SET_SYM_WED: Список символов для СР (';'-разд.)
  _inputs.SET_SYM_THU               = Inp_SET_SYM_THU;                                              // SET_SYM_THU: Список символов для ЧТ (';'-разд.)
  _inputs.SET_SYM_FRI               = Inp_SET_SYM_FRI;                                              // SET_SYM_FRI: Список символов для ПТ (';'-разд.)
  _inputs.SET_SYM_SAT               = Inp_SET_SYM_SAT;                                              // SET_SYM_SAT: Список символов для СБ (';'-разд.)
  _inputs.SET_SYM_SUN               = Inp_SET_SYM_SUN;                                              // SET_SYM_SUN: Список символов для ВС (';'-разд.)
  _inputs.FIL_TIM_MON               = Inp_FIL_TIM_MON;                                              // FIL_TIM_MON: Разрешенный период торговли в ПН (HH:MM-HH:MM)
  _inputs.FIL_TIM_TUE               = Inp_FIL_TIM_TUE;                                              // FIL_TIM_MON: Разрешенный период торговли в ВТ (HH:MM-HH:MM)
  _inputs.FIL_TIM_WED               = Inp_FIL_TIM_WED;                                              // FIL_TIM_MON: Разрешенный период торговли в СР (HH:MM-HH:MM)
  _inputs.FIL_TIM_THU               = Inp_FIL_TIM_THU;                                              // FIL_TIM_MON: Разрешенный период торговли в ЧТ (HH:MM-HH:MM)
  _inputs.FIL_TIM_FRI               = Inp_FIL_TIM_FRI;                                              // FIL_TIM_MON: Разрешенный период торговли в ПТ (HH:MM-HH:MM)
  _inputs.FIL_TIM_SAT               = Inp_FIL_TIM_SAT;                                              // FIL_TIM_MON: Разрешенный период торговли в СБ (HH:MM-HH:MM)
  _inputs.FIL_TIM_SUN               = Inp_FIL_TIM_SUN;                                              // FIL_TIM_MON: Разрешенный период торговли в ВС (HH:MM-HH:MM)
  _inputs.FIL_NWS_ENB               = Inp_FIL_NWS_ENB;                                              // FIL_NWS_ENB: Включить фильтрацию вокруг новостей
  _inputs.FIL_NWS_NAM               = Inp_FIL_NWS_NAM;                                              // FIL_NWS_NAM: Список имен новостей (';'-разд.)
  _inputs.FIL_NWS_NIF               = Inp_FIL_NWS_NIF;                                              // FIL_NWS_NIF: Загрузить имена новостей из файла 'dvfssi_news.txt'
  _inputs.FIL_NWS_BMN               = Inp_FIL_NWS_BMN;                                              // FIL_NWS_BMN: Время до новостей, мин
  _inputs.FIL_NWS_AMN               = Inp_FIL_NWS_AMN;                                              // FIL_NWS_AMN: Время после новостей, мин
  _inputs.FIL_NWS_STF               = Inp_FIL_NWS_STF;                                              // FIL_NWS_STF: TF свечи после новости для откл. торговли
  _inputs.FIL_NWS_SBS               = Inp_FIL_NWS_SBS;                                              // FIL_NWS_SBS: Max свеча после новости для откл. торговли, пункт
  _inputs.FIL_TP_MIN                = Inp_FIL_TP_MIN;                                               // FIL_TP_MIN: Мин допустимый TP, пункт
  _inputs.ENT_MM_TYP                = Inp_ENT_MM_TYP;                                               // ENT_MM_TYP: Тип лота
  _inputs.ENT_MM_VAL                = Inp_ENT_MM_VAL;                                               // ENT_MM_VAL: Значение для расчета лота
  _inputs.ENT_PO_SHT                = Inp_ENT_PO_SHT;                                               // ENT_PO_SHT: Сдвиг EP отложенного ордера от EP, пункт (0-откл)
  _inputs.ENT_PO_EXP                = Inp_ENT_PO_EXP;                                               // ENT_PO_EXP: Срок истечения отложенного ордера, сек (0-откл)
  _inputs.ENT_SL_PNT                = Inp_ENT_SL_PNT;                                               // ENT_SL_PNT: Фиксированный SL, пункт
  _inputs.ENT_TP_TYP                = Inp_ENT_TP_TYP;                                               // ENT_TP_TYP: Тип TP
  _inputs.ENT_TP_PNT                = Inp_ENT_TP_PNT;                                               // ENT_TP_PNT: Фиксированный TP, пункт
  _inputs.ENT_TP_RR                 = Inp_ENT_TP_RR;                                                // ENT_TP_RR: TP RR
  _inputs._NOT_ALR_ENB              = Inp__NOT_ALR_ENB;                                             // NOT_ALR_ENB: Включить оповещения в терминале
  _inputs._NOT_PUS_ENB              = Inp__NOT_PUS_ENB;                                             // NOT_PUS_ENB: Включить мобильные push уведомления
  _inputs._GUI_ENB                  = Inp__GUI_ENB;                                                 // GUI_ENB: Графика включена
  _inputs._MS_MGC                   = Inp__MS_MGC;                                                  // MS_MGC: Expert Adviser ID - Magic
  _inputs._MS_EGP                   = Inp__MS_EGP;                                                  // MS_EGP: Expert Adviser Global Prefix
  _inputs._MS_LOG_LL                = Inp__MS_LOG_LL;                                               // MS_LOG_LL: Log Level
  _inputs._MS_LOG_FI                = Inp__MS_LOG_FI;                                               // MS_LOG_FI: Log Filter IN String (use `;` as sep)
  _inputs._MS_LOG_FO                = Inp__MS_LOG_FO;                                               // MS_LOG_FO: Log Filter OUT String (use `;` as sep)
  _inputs._MS_COM_EN                = Inp__MS_COM_EN;                                               // MS_COM_EN: Comment Enable (turn off for fast testing)
  _inputs._MS_COM_IS                = Inp__MS_COM_IS;                                               // MS_COM_IS: Comment Interval, Sec
  _inputs._MS_COM_CW                = Inp__MS_COM_CW;                                               // MS_COM_EW: Comment Custom Window
  _inputs._MS_TIM_MS                = Inp__MS_TIM_MS;                                               // MS_TIM_MS: Timer Interval, ms
  _inputs._MS_MOC_SYM_1             = Inp__MS_MOC_SYM_1;                                            // _MS_MOC_SYM_1: Mock Levels for Symbol #1 (''-off)
  _inputs._MS_MOC_LNG_1             = Inp__MS_MOC_LNG_1;                                            // _MS_MOC_LNG_1: Mock Long Level for Symbol #1
  _inputs._MS_MOC_SHT_1             = Inp__MS_MOC_SHT_1;                                            // _MS_MOC_SHT_1: Mock Short Level for Symbol #1
  _inputs._MS_MOC_SYM_2             = Inp__MS_MOC_SYM_2;                                            // _MS_MOC_SYM_2: Mock Levels for Symbol #2 (''-off)
  _inputs._MS_MOC_LNG_2             = Inp__MS_MOC_LNG_2;                                            // _MS_MOC_LNG_2: Mock Long Level for Symbol #2
  _inputs._MS_MOC_SHT_2             = Inp__MS_MOC_SHT_2;                                            // _MS_MOC_SHT_2: Mock Short Level for Symbol #2
}


//+------------------------------------------------------------------+
//| Constructor
//+------------------------------------------------------------------+
void CDVFSSIBotInputs::CDVFSSIBotInputs():
       GLB_BOT_MODE(TRADING),
       GLB_SLC_DPT(100),
       SET_TYP_MON(COMBINED),
       SET_TYP_TUE(COMBINED),
       SET_TYP_WED(COMBINED),
       SET_TYP_THU(COMBINED),
       SET_TYP_FRI(COMBINED),
       SET_TYP_SAT(NONE),
       SET_TYP_SUN(NONE),
       SET_SYM_MON("GBPUSD;EURUSD"),
       SET_SYM_TUE("GBPUSD;EURUSD"),
       SET_SYM_WED("GBPUSD;EURUSD"),
       SET_SYM_THU("GBPUSD;EURUSD"),
       SET_SYM_FRI("GBPUSD;EURUSD"),
       SET_SYM_SAT(""),
       SET_SYM_SUN(""),
       FIL_TIM_MON("09:00-22:00"),
       FIL_TIM_TUE("09:00-22:00"),
       FIL_TIM_WED("09:00-22:00"),
       FIL_TIM_THU("09:00-22:00"),
       FIL_TIM_FRI("09:00-18:00"),
       FIL_TIM_SAT(""),
       FIL_TIM_SUN(""),
       FIL_NWS_ENB(true),
       FIL_NWS_NAM(""),
       FIL_NWS_NIF(true),
       FIL_NWS_BMN(-60),
       FIL_NWS_AMN(120),
       FIL_NWS_STF(PERIOD_H1),
       FIL_NWS_SBS(60),
       FIL_TP_MIN(30),
       ENT_MM_TYP(ENUM_MM_TYPE_BALANCE_PERCENT),
       ENT_MM_VAL(0.5),
       ENT_PO_SHT(15),
       ENT_PO_EXP(2*60*60),
       ENT_SL_PNT(15),
       ENT_TP_TYP(FIXED_PNT),
       ENT_TP_PNT(30),
       ENT_TP_RR(2.0),
       _NOT_ALR_ENB(true),
       _NOT_PUS_ENB(true),
       _GUI_ENB(true),
       _MS_MGC(20250203),
       _MS_EGP("DVFSSI"),
       _MS_LOG_LL(INFO),
       _MS_LOG_FI(""),
       _MS_LOG_FO(""),
       _MS_COM_EN(true),
       _MS_COM_IS(30),
       _MS_COM_CW(true),
       _MS_TIM_MS(30000),
       __MS_NWS_DEL(10),
       __MS_LIC_DUR_SEC(0*24*60*60),
       _MS_MOC_SYM_1(""),
       _MS_MOC_SYM_2(""){

};


//+------------------------------------------------------------------+
//| Check struc before Init
//+------------------------------------------------------------------+
bool CDVFSSIBotInputs::CheckBeforeInit() {
  LastErrorMessage = "";
  if(!(GLB_SLC_DPT>0)) LastErrorMessage = "'GLB_SLC_DPT' must satisfy condition: GLB_SLC_DPT>0";
  if(!(ENT_MM_VAL > 0)) LastErrorMessage = "'ENT_MM_VAL' must satisfy condition: ENT_MM_VAL > 0";
  if(!(ENT_SL_PNT > 0)) LastErrorMessage = "'ENT_SL_PNT' must satisfy condition: ENT_SL_PNT > 0";
  if(!(ENT_TP_PNT > 0)) LastErrorMessage = "'ENT_TP_PNT' must satisfy condition: ENT_TP_PNT > 0";
  if(!(ENT_TP_RR > 0)) LastErrorMessage = "'ENT_TP_RR' must satisfy condition: ENT_TP_RR > 0";

  return LastErrorMessage == "";
}
// GENERATED CODE == END == DO NOT REMOVE THIS COMMENT



