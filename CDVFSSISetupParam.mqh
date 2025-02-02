// #todo remove this file from prj
//+------------------------------------------------------------------+
//|                                            CDVFSSISetupParam.mqh |
//|                                                  Denis Kislitsyn |
//|                                             https://kislitsyn.me |
//+------------------------------------------------------------------+
//#include <Generic\HashMap.mqh>
//#include <Arrays\ArrayString.mqh>
//#include <Arrays\ArrayObj.mqh>
//#include <Arrays\ArrayDouble.mqh>
//#include <Arrays\ArrayLong.mqh>
//#include <Trade\TerminalInfo.mqh>
//#include <Trade\DealInfo.mqh>
//#include <Charts\Chart.mqh>
//#include <Math\Stat\Math.mqh>
//#include <Trade\OrderInfo.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>

#include "Include\DKStdLib\Common\CDKString.mqh"
#include "Include\DKStdLib\Common\DKDatetime.mqh"
#include "Include\DKStdLib\Common\CDKBarTag.mqh"
#include "Include\DKStdLib\TradingManager\CDKSymbolInfo.mqh"
#include "Include\DKStdLib\TradingManager\CDKPositionInfo.mqh"
#include "Include\DKStdLib\TradingManager\CDKTrade.mqh"
#include "Include\DKStdLib\Logger\CDKLogger.mqh"

class CTimeInterval : public CObject {
public:
  datetime                    From;
  datetime                    To;
};

struct CDirParam {
  ENUM_TIMEFRAMES             TIMEFRAME;
  uint                        PERIOD;
  ENUM_SERIESMODE             FIELD;
  double                      OFFSET;
  uint                        DELAY;
  datetime                    CLOSETIME;
  double                      SIZE;
  
  string                      ToString() {
    return StringFormat("%s/%d/%s/%f/%d/%s/%0.2f",
                        TimeframeToString(TIMEFRAME),
                        PERIOD,
                        CSetupParam::SeriesModeToString(FIELD, ""),
                        OFFSET,
                        DELAY,
                        TimeToString(CLOSETIME, TIME_MINUTES | TIME_SECONDS),
                        SIZE);
  };
};  

struct COpenVolume {
  double                      Volume;
  ENUM_DK_POS_TYPE            Dir;
  ulong                       Ticket;
  datetime                    Time;
  double                      PriceHit;
  
  void                        InitFree() {
    Volume = 0.0;
    Dir = BUY;
    Ticket = 0;
    Time = 0;
  }
  
  void                        Init(const double _lot, const ENUM_DK_POS_TYPE _dir, const ulong _ticket, const datetime _dt) {
    Volume = _lot;
    Dir = _dir;
    Ticket = _ticket;
    Time = _dt;
  }
};

enum ENUM_SETUP_RETCODE {
  SETUP_RETCODE_INIT_SUCCESS                    = -10,                   // Init Success
  SETUP_RETCODE_INIT_ERROR_WRONG_QUIK_PARAM_CNT = +10,                   // Init Error: Wrong Quik Param Str Format: PARAM_CNT must be >=15
  SETUP_RETCODE_INIT_ERROR_WRONG_SYM            = +11,                   // Init Error: Wrong Symbol Name in Quik Param Str
  SETUP_RETCODE_INIT_ERROR_NO_WORKTIME_SET      = +12,                   // Init Error: No WORKTIME set
  
  SETUP_RETCODE_SIG_LONG                        = -20,                   // Signal: Long
  SETUP_RETCODE_SIG_SHORT                       = -21,                   // Signal: Short
  SETUP_RETCODE_SIG_NO                          = +20,                   // Signal: No
  SETUP_RETCODE_SIG_FIL_OUT_HAS_VOLUME          = +21,                   // Signal: Filtered Out by Volume in Market
  SETUP_RETCODE_SIG_FIL_OUT_COPYRATES_ERROR     = +22,                   // Signal: CopyRates Error
  SETUP_RETCODE_SIG_FIL_OUT_LOT_PARAM_EMPTY     = +23,                   // Signal: Lot Param is Empty for Dir
  SETUP_RETCODE_SIG_FIL_OUT_POS_DIR_NOT_EQUAL_SIG = +24,                 // Signal: Pos Dir differs Signal Dir
  
  SETUP_RETCODE_OPEN_POS_SUCCESS                = -30,                   // OpenPos: Success
  SETUP_RETCODE_OPEN_POS_ERROR_TRADE            = +30,                   // OpenPos: CTrade Error
  
  SETUP_RETCODE_CLOSE_POS_SUCCESS               = -40,                   // ClosePos: Success
  SETUP_RETCODE_CLOSE_POS_NOT_POS_FOUND         = -41,                   // ClosePos: No Pos Founnd in Market
  SETUP_RETCODE_CLOSE_POS_ERROR_TRADE           = +40,                   // ClosePos: CTrade Error
  
};

class CSetupParam : public CObject {  
private:
  CDKLogger*                  Logger;
  CDKTrade                    Trade;
  ulong                       Magic;
  
  string                      QuikStrSep;
  string                      WorkTimeIntSep;

public:
  int                         ID;
  string                      QuikStr;
  
  CDKSymbolInfo               Sym;
  CArrayObj                   WORKTIME;                 
  CDirParam                   ParamL;
  CDirParam                   ParamS;
  
  CDKBarTag                   LevelL;
  CDKBarTag                   LevelS;

  COpenVolume                 OpenVolume;
  
  void                        CSetupParam::CSetupParam();
  void                        CSetupParam::~CSetupParam();            
  bool                        CSetupParam::AddWorkTime(const datetime _from, const datetime _to);            
  bool                        CSetupParam::ParseAndAddWorkTime(const string _str);

  ENUM_SETUP_RETCODE          CSetupParam::Init(const int _id, const string _quik_str, CDKLogger* _logger, CDVFSSIBotInputs& _inputs);
  
  int                         CSetupParam::GetActiveWorkTime(const datetime _dt = 0);
  
  datetime                    CSetupParam::GetCloseTime(const ENUM_DK_POS_TYPE _dir);
  void                        CSetupParam::SetCloseTime(const ENUM_DK_POS_TYPE _dir, const datetime _dt);
  int                         CSetupParam::IsCloseTime(const ENUM_DK_POS_TYPE _dir, const datetime _dt = 0);
  datetime                    CSetupParam::MoveCloseTimeToNextDay(const ENUM_DK_POS_TYPE _dir);
  
  ENUM_SETUP_RETCODE          CSetupParam::GetSignal();
  ENUM_SETUP_RETCODE          CSetupParam::OpenOnSignal();
  
  ENUM_SETUP_RETCODE          CSetupParam::ClosePos();
  
  int                         CSetupParam::GetDirPosInMarket();
  
  void                        CSetupParam::DrawPosition();
  void                        CSetupParam::DrawSignal();
  void                        CSetupParam::EraseSignal();
  
  static ENUM_SERIESMODE      CSetupParam::StringToSeriesMode(string _str, ENUM_SERIESMODE _default);
  static string               CSetupParam::SeriesModeToString(ENUM_SERIESMODE _mode, string _default);
  static double               CSetupParam::GetMqlRateValue(MqlRates& _rate, const ENUM_SERIESMODE _mode);
  
  void                        CSetupParam::SaveTradeToTerminal();
  void                        CSetupParam::LoadTradeFromTerminal();
};

ENUM_SERIESMODE CSetupParam::StringToSeriesMode(string _str, ENUM_SERIESMODE _default) {
  StringToUpper(_str);
  if(_str == "OPEN") return MODE_OPEN;
  if(_str == "HIGH") return MODE_HIGH;
  if(_str == "LOW") return MODE_LOW;
  if(_str == "CLOSE") return MODE_CLOSE;
  
  return _default;
}

string CSetupParam::SeriesModeToString(ENUM_SERIESMODE _mode, string _default) {
  if(_mode == MODE_OPEN) return "OPEN";
  if(_mode == MODE_HIGH) return "HIGH";
  if(_mode == MODE_LOW) return "LOW";
  if(_mode == MODE_CLOSE) return "CLOSE";
  
  return _default;  
}

void CSetupParam::CSetupParam() {
  QuikStrSep = ";";
  WorkTimeIntSep = "-";
}

void CSetupParam::~CSetupParam(){
  WORKTIME.Clear();
}

bool CSetupParam::AddWorkTime(const datetime _from, const datetime _to) {
  CTimeInterval* time_int = new CTimeInterval;
  time_int.From = _from;
  time_int.To = _to;
  
  WORKTIME.Add(time_int);
  return true;
}

bool CSetupParam::ParseAndAddWorkTime(const string _str) {
  CDKString wt_str;
  CArrayString wt_arr;
  wt_str.Assign(_str);
  if(wt_str.Split(WorkTimeIntSep, wt_arr) < 2) return false;
  
  AddWorkTime(StringToTime(wt_arr.At(0)), StringToTime(wt_arr.At(1)));
  return true;
}

ENUM_SETUP_RETCODE CSetupParam::Init(const int _id, const string _quik_str, CDKLogger* _logger, CDVFSSIBotInputs& _inputs) {
  // Example: "SiH5;M5;70;Open;0.00001;10;10:14:50;1;M5;70;Low;0.00001;10;10:14:50;1 ;WT1;WT2;...
  // Idx:     "   0; 1; 2;   3;      4; 5;       6;7; 8; 9; 10;     11;12;      13;14; 15; 16;...
  ID = _id;
  QuikStr = _quik_str;
  Magic = _inputs._MS_MGC;
  
  Logger = _logger;

  LevelL.Init(Sym.Name(), ParamL.TIMEFRAME);
  LevelS.Init(Sym.Name(), ParamS.TIMEFRAME);
  OpenVolume.InitFree();
  
  CArrayString arr;
  CDKString str;
  str.Assign(QuikStr);
  if(str.Split(QuikStrSep, arr) < 15) return SETUP_RETCODE_INIT_ERROR_WRONG_QUIK_PARAM_CNT;

  if(!Sym.Name(arr[0])) return SETUP_RETCODE_INIT_ERROR_WRONG_SYM;

  datetime dt_curr = TimeCurrent();
  ParamL.TIMEFRAME =      StringToTimeframe(arr.At(1));
  ParamL.PERIOD =    (int)StringToInteger(arr.At(2));
  ParamL.FIELD =          StringToSeriesMode(arr.At(3), MODE_HIGH);
  ParamL.OFFSET =         StringToDouble(arr.At(4));
  ParamL.DELAY =     (int)StringToInteger(arr.At(5));
  ParamL.CLOSETIME =      UpdateDateInMqlDateTime(StringToTime(arr.At(6)), dt_curr);
  ParamL.SIZE =           StringToDouble(arr.At(7));

  ParamS.TIMEFRAME =      StringToTimeframe(arr.At(8));
  ParamS.PERIOD =    (int)StringToInteger(arr.At(9));
  ParamS.FIELD =          StringToSeriesMode(arr.At(10), MODE_LOW);
  ParamS.OFFSET =         StringToDouble(arr.At(11));
  ParamS.DELAY =     (int)StringToInteger(arr.At(12));
  ParamS.CLOSETIME =      UpdateDateInMqlDateTime(StringToTime(arr.At(13)), dt_curr);
  ParamS.SIZE =           StringToDouble(arr.At(14));
  
  for(int i=15;i<arr.Total();i++) 
    ParseAndAddWorkTime(arr.At(i));
    
  if(WORKTIME.Total() <= 0) {
    if(_inputs.WORKTIME1 != "") ParseAndAddWorkTime(_inputs.WORKTIME1);
    if(_inputs.WORKTIME2 != "") ParseAndAddWorkTime(_inputs.WORKTIME2);
    if(_inputs.WORKTIME3 != "") ParseAndAddWorkTime(_inputs.WORKTIME3);
  }    
  
  if(WORKTIME.Total() <= 0)
    return SETUP_RETCODE_INIT_ERROR_NO_WORKTIME_SET;
  
  Trade.Init(Sym.Name(), _inputs._MS_MGC, 0, Logger);
  
  LoadTradeFromTerminal();
  
  return SETUP_RETCODE_INIT_SUCCESS;  
}

int CSetupParam::GetActiveWorkTime(const datetime _dt = 0) {
  datetime dt = (_dt == 0) ? TimeCurrent() : _dt;
  for(int i=0;i<WORKTIME.Total();i++) {
    CTimeInterval* ti = WORKTIME.At(i);
    if(IsTimeAfterUpdatedTimeToToday(dt, ti.From) && !IsTimeAfterUpdatedTimeToToday(dt, ti.To)) 
      return i;   
  }
  
  return -1;
}

datetime CSetupParam::GetCloseTime(const ENUM_DK_POS_TYPE _dir) {
  return _dir == BUY ? ParamL.CLOSETIME : ParamS.CLOSETIME;
}

void CSetupParam::SetCloseTime(const ENUM_DK_POS_TYPE _dir, const datetime _dt) {
  if(_dir == BUY) ParamL.CLOSETIME = _dt;
  else ParamS.CLOSETIME = _dt;
}

int CSetupParam::IsCloseTime(const ENUM_DK_POS_TYPE _dir, const datetime _dt = 0) {
  datetime dt = (_dt == 0) ? TimeCurrent() : _dt;
  datetime close_dt = GetCloseTime(_dir);
  return _dt > close_dt;
}

datetime CSetupParam::MoveCloseTimeToNextDay(const ENUM_DK_POS_TYPE _dir) {
  datetime dt = (_dir == BUY) ? ParamL.CLOSETIME : ParamS.CLOSETIME;
  MqlDateTime dt_mql;
  TimeToStruct(dt, dt_mql);
  UpdateDateInMqlDateTime(dt_mql, dt + 24*60*60);
  return StructToTime(dt_mql);
}

ENUM_SETUP_RETCODE CSetupParam::GetSignal() {
  int lev_l_idx = iHighest(Sym.Name(), ParamL.TIMEFRAME, ParamL.FIELD, ParamL.PERIOD, 2);
  int lev_s_idx = iLowest(Sym.Name(), ParamS.TIMEFRAME, ParamS.FIELD, ParamS.PERIOD, 2);
  
  MqlRates lev_l_rate[], lev_s_rate[]; 
  MqlRates bar1_l_rate[], bar1_s_rate[]; 
  if(CopyRates(Sym.Name(), ParamL.TIMEFRAME, lev_l_idx, 1, lev_l_rate) <= 0 ||
     CopyRates(Sym.Name(), ParamS.TIMEFRAME, lev_s_idx, 1, lev_s_rate) <= 0 ||
     CopyRates(Sym.Name(), ParamL.TIMEFRAME, 1, 1, bar1_l_rate) <= 0 ||
     CopyRates(Sym.Name(), ParamS.TIMEFRAME, 1, 1, bar1_s_rate) <= 0)
    return SETUP_RETCODE_SIG_FIL_OUT_COPYRATES_ERROR;  
  
  
  double lev_l_price = CSetupParam::GetMqlRateValue(lev_l_rate[0], ParamL.FIELD);
  double lev_s_price = CSetupParam::GetMqlRateValue(lev_s_rate[0], ParamS.FIELD);
  LevelL.SetIndexAndValue(ParamL.PERIOD, lev_l_price);
  LevelS.SetIndexAndValue(ParamS.PERIOD, lev_s_price);
  
  double bar1_l_price = bar1_l_rate[0].close;
  double bar1_s_price = bar1_s_rate[0].close;
  
  if(bar1_l_price >= lev_l_price + ParamL.OFFSET) 
    return SETUP_RETCODE_SIG_LONG;
    
  if(bar1_s_price <= lev_s_price - ParamS.OFFSET) 
    return SETUP_RETCODE_SIG_SHORT;    
     
  return SETUP_RETCODE_SIG_NO;  
}

int CSetupParam::GetDirPosInMarket() {
  for(int i=0;i<PositionsTotal();i++) {
    CDKPositionInfo pos;
    if(!pos.SelectByIndex(i)) continue;
    if(pos.Symbol() != Sym.Name()) continue;
    
    return GetPosDirSign(pos.PositionType());
  }
  
  return 0;
}

ENUM_SETUP_RETCODE CSetupParam::OpenOnSignal() {
  if(OpenVolume.Volume > 0.0) return SETUP_RETCODE_SIG_FIL_OUT_HAS_VOLUME; 
  
  ENUM_SETUP_RETCODE sig = GetSignal();
  if(sig > 0) return sig;
  
  ENUM_DK_POS_TYPE dir = (sig == SETUP_RETCODE_SIG_LONG) ? BUY : SELL;
  
  double lot = (dir == BUY) ? ParamL.SIZE : ParamS.SIZE;
  if(lot <= 0) return SETUP_RETCODE_SIG_FIL_OUT_LOT_PARAM_EMPTY;
  
  int pos_dir_in_market = GetDirPosInMarket();
  if(pos_dir_in_market != 0 && pos_dir_in_market != GetPosDirSign((ENUM_POSITION_TYPE)dir)) 
    return SETUP_RETCODE_SIG_FIL_OUT_POS_DIR_NOT_EQUAL_SIG;
  
  string comment = StringFormat("%s_%d_%s_%s_EN", Logger.Name, ID+1, Sym.Name(), 
                                TimeframeToString((dir == BUY) ? ParamL.TIMEFRAME : ParamS.TIMEFRAME));

  uint delay_before_open_sec = (dir == BUY) ? ParamL.DELAY : ParamS.DELAY;
  if(delay_before_open_sec > 0)
    Sleep(delay_before_open_sec*1000);
  
  ulong ticket = 0;
  if(dir == BUY) 
    ticket = Trade.Buy(lot, Sym.Name(), 0.0, 0.0, 0.0, comment);
  else
    ticket = Trade.Sell(lot, Sym.Name(), 0.0, 0.0, 0.0, comment);
  
  if(ticket != 0) {
    OpenVolume.Init(lot, dir, ticket, TimeCurrent());
    SaveTradeToTerminal();
    ParamL.CLOSETIME = UpdateDateInMqlDateTime(ParamL.CLOSETIME, TimeCurrent()+24*60*60); // Next close check only tomorrow
    ParamS.CLOSETIME = UpdateDateInMqlDateTime(ParamS.CLOSETIME, TimeCurrent()+24*60*60); // Next close check only tomorrow
    return SETUP_RETCODE_OPEN_POS_SUCCESS;
  }
  
  return SETUP_RETCODE_OPEN_POS_ERROR_TRADE;
}

ENUM_SETUP_RETCODE CSetupParam::ClosePos() {
  // 02. Find pos
  int close_cnt = 0;
  for(int i=0;i<PositionsTotal();i++){
    CDKPositionInfo pos;
    if(!pos.SelectByIndex(i)) continue;
    if(pos.Symbol() != Sym.Name()) continue;
    
    bool res = false;

    string comment = StringFormat("%s_%d_%s_%s_EX", Logger.Name, ID+1, Sym.Name(),
                                  TimeframeToString((OpenVolume.Dir == BUY) ? ParamL.TIMEFRAME : ParamS.TIMEFRAME));
    if(pos.PositionType() == POSITION_TYPE_BUY)
      res = Trade.Sell(OpenVolume.Volume, Sym.Name(), 0, 0, 0, comment);
    else
      res = Trade.Buy(OpenVolume.Volume, Sym.Name(), 0, 0, 0, comment);
  
      
    if(!res) return SETUP_RETCODE_CLOSE_POS_ERROR_TRADE;
    
    OpenVolume.InitFree();
    return SETUP_RETCODE_CLOSE_POS_SUCCESS;
  }  
  
  return SETUP_RETCODE_CLOSE_POS_NOT_POS_FOUND;
}

void CSetupParam::DrawPosition() {
  if(Sym.Name() != Symbol()) return;
  
  CChartObjectTrend line;
  string name = StringFormat("%s_POS_%d_%I64u", Logger.Name, ID+1, OpenVolume.Ticket);
  string desc = StringFormat("#%d %s %s #%I64u", 
                             ID+1, 
                             (OpenVolume.Dir == BUY) ? TimeframeToString(ParamL.TIMEFRAME) : TimeframeToString(ParamS.TIMEFRAME),
                             PositionTypeToString((ENUM_POSITION_TYPE)OpenVolume.Dir),
                             OpenVolume.Ticket
                             );
  double price = (OpenVolume.Dir == BUY) ? LevelL.GetValue() : LevelS.GetValue();
  datetime dt2 = (OpenVolume.Dir == BUY) ? LevelL.GetTime() : LevelS.GetTime();

  line.Create(0, name, 0,
              dt2, price,
              TimeCurrent(), price
              );
  line.Color((OpenVolume.Dir == BUY) ? clrGreen : clrRed);
  line.Style(STYLE_DASHDOT);
  line.Description(desc);
  
  line.Detach();
}

void CSetupParam::DrawSignal() {
  if(Sym.Name() != Symbol()) return;
  
  string name_l = StringFormat("%s_SIG_L_%d", Logger.Name, ID+1);
  string name_s = StringFormat("%s_SIG_S_%d", Logger.Name, ID+1);
  
  string desc_l = StringFormat("#%d LONG %s", ID+1, TimeframeToString(ParamL.TIMEFRAME));
  string desc_s = StringFormat("#%d SHORT %s", ID+1, TimeframeToString(ParamS.TIMEFRAME));
  
  CChartObjectTrend line;
  
  // BUY line
  if(ParamL.SIZE > 0.0 && LevelL.GetTime() != 0) {
    line.Create(0, name_l, 0,
                LevelL.GetTime(), LevelL.GetValue(),
                TimeCurrent(), LevelL.GetValue()
                );
    line.Color(clrGreen);
    line.Style(STYLE_DOT);
    line.Description(desc_l);  
    line.Detach();
  }
  
  // SELL Line
  if(ParamS.SIZE > 0.0 && LevelS.GetTime() != 0) {
    line.Create(0, name_s, 0,
                LevelS.GetTime(), LevelS.GetValue(),
                TimeCurrent(), LevelS.GetValue()
                );
    line.Color(clrRed);
    line.Style(STYLE_DOT);
    line.Description(desc_s);  
    line.Detach();  
  }
}

void CSetupParam::EraseSignal() {
  if(Sym.Name() != Symbol()) return;
  
  string name_l = StringFormat("%s_SIG_L_%d", Logger.Name, ID+1);
  string name_s = StringFormat("%s_SIG_S_%d", Logger.Name, ID+1);
  
  ObjectDelete(0, name_l);
  ObjectDelete(0, name_s);  
}

double CSetupParam::GetMqlRateValue(MqlRates& _rate, const ENUM_SERIESMODE _mode) {
  if(_mode == MODE_OPEN) return _rate.open;
  if(_mode == MODE_HIGH) return _rate.high;
  if(_mode == MODE_LOW) return _rate.low;
  if(_mode == MODE_CLOSE) return _rate.close;
  
  return 0.0;
}

//+------------------------------------------------------------------+
//| Save trade to terminal
//+------------------------------------------------------------------+
void CSetupParam::SaveTradeToTerminal() {
  string prefix = StringFormat("%d_%d_%s", Magic, ID+1, QuikStr);
  
  GlobalVariableSet(StringFormat("%s_VOL", prefix), OpenVolume.Volume);
  GlobalVariableSet(StringFormat("%s_DIR", prefix), (int)OpenVolume.Dir);
  GlobalVariableSet(StringFormat("%s_TIM", prefix), OpenVolume.Time);
  GlobalVariableSet(StringFormat("%s_TIC", prefix), OpenVolume.Ticket);
  GlobalVariableSet(StringFormat("%s_PRI", prefix), OpenVolume.PriceHit);
  
  LSF_INFO(StringFormat("GVAR_PRF=%s; VOL=%0.2f; DIR=%s; TICKET=%I64u; DT=%s; PRICE=%f",
                        prefix, 
                        OpenVolume.Volume, PositionTypeToString((ENUM_POSITION_TYPE)OpenVolume.Dir), 
                        OpenVolume.Ticket,
                        TimeToString(OpenVolume.Time, TIME_DATE | TIME_MINUTES | TIME_SECONDS),
                        OpenVolume.PriceHit
                        ));
}

//+------------------------------------------------------------------+
//| Load trade from terminal
//+------------------------------------------------------------------+
void CSetupParam::LoadTradeFromTerminal() {
  string prefix = StringFormat("%d_%d_%s", Magic, ID+1, QuikStr);
  
  // Load pos for setup from Terminal
  double vol = GlobalVariableGet(StringFormat("%s_VOL", prefix));
  if(vol <= 0) return;
  
  OpenVolume.Volume = vol;
  OpenVolume.Dir = (ENUM_DK_POS_TYPE)GlobalVariableGet(StringFormat("%s_DIR", prefix));
  OpenVolume.Time = (datetime)GlobalVariableGet(StringFormat("%s_TIM", prefix));
  OpenVolume.Ticket = (ulong)GlobalVariableGet(StringFormat("%s_TIC", prefix));
  OpenVolume.PriceHit = GlobalVariableGet(StringFormat("%s_PRI", prefix));
  
  LSF_INFO(StringFormat("GVAR_PRF=%s; VOL=%0.2f; DIR=%s; TICKET=%I64u; DT=%s; PRICE=%f",
                        prefix, 
                        OpenVolume.Volume, PositionTypeToString((ENUM_POSITION_TYPE)OpenVolume.Dir), 
                        OpenVolume.Ticket,
                        TimeToString(OpenVolume.Time, TIME_DATE | TIME_MINUTES | TIME_SECONDS),
                        OpenVolume.PriceHit
                        ));
                        
  // Check pos in still in market
  CDKPositionInfo pos;
  if(!pos.SelectByTicket(OpenVolume.Ticket) || pos.Volume() < OpenVolume.Volume) {
    LSF_WARN(StringFormat("Restored pos not found in market: TICKET=%I64u; GVAR_PRF=%s; VOL=%0.2f; DIR=%s; DT=%s; PRICE=%f",
                          OpenVolume.Ticket,
                          prefix, 
                          OpenVolume.Volume, PositionTypeToString((ENUM_POSITION_TYPE)OpenVolume.Dir), 
                          TimeToString(OpenVolume.Time, TIME_DATE | TIME_MINUTES | TIME_SECONDS),
                          OpenVolume.PriceHit
                          ));
    Alert(StringFormat("Для сетапа #%d не удалось восстановить позицию #%I64u, потому что ее нет в рынке", ID+1, OpenVolume.Ticket));
    OpenVolume.InitFree();
  }
  else if(pos.Volume() < OpenVolume.Volume) {
    LSF_WARN(StringFormat("Restored pos has not enougth market vol: TICKET=%I64u; VOL_RESTORED=%0.2f; VOL_MARKET=%0.2f; GVAR_PRF=%s; DIR=%s; DT=%s; PRICE=%f",
                          OpenVolume.Ticket,
                          OpenVolume.Volume,
                          pos.Volume(),
                          prefix, 
                          PositionTypeToString((ENUM_POSITION_TYPE)OpenVolume.Dir), 
                          TimeToString(OpenVolume.Time, TIME_DATE | TIME_MINUTES | TIME_SECONDS),
                          OpenVolume.PriceHit
                          ));    
    Alert(StringFormat("Для сетапа #%d не удалось восстановить позицию #%I64u, потому что у нее недостаточный объем %0.2f в рынке", 
                       ID+1, OpenVolume.Ticket, OpenVolume.Volume));
    OpenVolume.InitFree();
  }
}