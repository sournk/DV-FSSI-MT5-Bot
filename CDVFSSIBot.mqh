//+------------------------------------------------------------------+
//|                                                   CDVFSSIBot.mqh |
//|                                                  Denis Kislitsyn |
//|                                             https://kislitsyn.me |
//+------------------------------------------------------------------+

#define CALENDAR_FILENAME "DVSTSSI_Calendar.bin" // Название файла для чтения/записи Календаря MQ5
#define NEWS_FILENAME "DVSTSSI_news.txt" // Название файла для чтения/записи новостей MQ5
#property tester_file CALENDAR_FILENAME  // Указание, чтобы MT5-Тестер подхватывал данный файл.
#property tester_file NEWS_FILENAME      // Указание, чтобы MT5-Тестер подхватывал данный файл.

#include <Generic\HashMap.mqh>
//#include <Arrays\ArrayString.mqh>
//#include <Arrays\ArrayObj.mqh>
//#include <Arrays\ArrayDouble.mqh>
//#include <Arrays\ArrayLong.mqh>
//#include <Trade\TerminalInfo.mqh>
//#include <Trade\DealInfo.mqh>
#include <Charts\Chart.mqh>
//#include <Math\Stat\Math.mqh>
//#include <Trade\OrderInfo.mqh>

//#include <ChartObjects\ChartObjectsShapes.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>
#include <ChartObjects\ChartObjectsArrows.mqh> 

//#include "Include\DKStdLib\Analysis\DKChartAnalysis.mqh"
#include "Include\DKStdLib\Common\DKNumPy.mqh"
#include "Include\DKStdLib\Common\CDKBarTag.mqh"

//#include "Include\DKStdLib\Common\CDKString.mqh"
//#include "Include\DKStdLib\Logger\CDKLogger.mqh"
//#include "Include\DKStdLib\TradingManager\CDKPositionInfo.mqh"
//#include "Include\DKStdLib\TradingManager\CDKTrade.mqh"
//#include "Include\DKStdLib\TradingManager\CDKTSLStep.mqh"
//#include "Include\DKStdLib\TradingManager\CDKTSLStepSpread.mqh"
//#include "Include\DKStdLib\TradingManager\CDKTSLFibo.mqh"
#include "Include\DKStdLib\TradingManager\CDKTSLPriceChannel.mqh"
//#include "Include\DKStdLib\Drawing\DKChartDraw.mqh"
//#include "Include\DKStdLib\History\DKHistory.mqh"

#include "Include\DKStdLib\Common\CDKString.mqh"
#include "Include\DKStdLib\Common\DKDatetime.mqh"
#include "Include\DKStdLib\Arrays\CDKArrayString.mqh"
#include "Include\DKStdLib\Bot\CDKBaseBot.mqh"

#include "Include\fxsaber\Calendar\Calendar.mqh"
#include "Include\fxsaber\Calendar\DST.mqh"

#include "CDVFSSIInputs.mqh"


enum ENUM_BOT_STATUS {
  UNKNOWN                         = -1,
  WAITING_SIGNAL                  =  0,
  STOP_TIME_NOT_ALLOWED           = 10,
  STOP_ON_NEWS_TIME               = 20,
  STOP_AFTER_HUGE_BAR_ON_NEWS     = 21,  
  STOP_AFTER_SL                   = 22,
  TRACKING_ORDER                  = 30,  
  TRACKING_POS                    = 31,
};

class CSymSet : public CObject {
public:
  string                     Sym;
  int                        IndSLCHndl;
  long                       ChartID;
  
  datetime                   SLC_DT;
  double                     SLC_U;
  double                     SLC_D;  
  int                        SLC_Dir;
  
  void                       CSymSet::CSymSet():
                               Sym(""),
                               IndSLCHndl(-1),
                               ChartID(-1),
                               SLC_DT(0),
                               SLC_U(0.0),
                               SLC_D(0.0),
                               SLC_Dir(0)
                             {}
};

class CDVFSSIBot : public CDKBaseBot<CDVFSSIBotInputs> {
public: // SETTINGS

protected:
  ENUM_BOT_STATUS            Status;

  string                     NewsNamesArr[];
  CALENDAR                   Calendar;
  datetime                   NewsLastDT;
  datetime                   NewsHugeBarStopTradeDT;
  datetime                   StopLossDT;
  datetime                   NewsNextUpdateDT;
  
  STimeInt                   WeekDayTime[7];
  CArrayString               WeekDaySym[7];
  ENUM_SETUP_TYPE            WeekDaySetup[7];
  
  CHashMap<string,CSymSet*>   SymSetHash;
public:
  // Constructor & init
  //void                       CDVFSSIBot::CDVFSSIBot(void);
  void                       CDVFSSIBot::~CDVFSSIBot(void);
  void                       CDVFSSIBot::InitChild();
  bool                       CDVFSSIBot::Check(void);

  // Event Handlers
  void                       CDVFSSIBot::OnDeinit(const int reason);
  void                       CDVFSSIBot::OnTick(void);
  void                       CDVFSSIBot::OnTrade(void);
  void                       CDVFSSIBot::OnTimer(void);
  double                     CDVFSSIBot::OnTester(void);
  void                       CDVFSSIBot::OnBar(void);
  
  void                       CDVFSSIBot::OnPositionStopLoss(ulong _position, ulong _deal);
  
  // Bot's logic
  void                       CDVFSSIBot::UpdateComment(const bool _ignore_interval = false);

  void                       CDVFSSIBot::MockLevels(CSymSet* _set, const double _price_close, const string _sym, const double _price_long, const double _price_short);
  int                        CDVFSSIBot::UpdateSLC(CSymSet* _set);
  void                       CDVFSSIBot::UpdateSLCOfAllSymbols();
  int                        CDVFSSIBot::CheckSLCBreak(CSymSet* _set);
  int                        CDVFSSIBot::GetSignal(const string _sym);
  int                        CDVFSSIBot::GetSignal_Combined(CArrayString& _sym_arr);

  ulong                      CDVFSSIBot::EnterPos(const string _sym, const int _dir, const ENUM_SETUP_TYPE _setup);
  ulong                      CDVFSSIBot::PlaceOrder(CSymSet* _set);
  ENUM_OPEN_POS_RETCODE      CDVFSSIBot::OpenOnSignal_Single(const string _sym);
  ENUM_OPEN_POS_RETCODE      CDVFSSIBot::OpenOnSignal_Combined(CArrayString& _sym_arr);
  ENUM_BOT_STATUS            CDVFSSIBot::OpenOnSignal();

  int                        CDVFSSIBot::CloseAllPos();
  int                        CDVFSSIBot::DeleteAllOrders();
  bool                       CDVFSSIBot::ExitMarket();  
  
  int                        CDVFSSIBot::CloseOnTime();
  
  bool                       CDVFSSIBot::IsChartOpen(const long _chart_id);
  
  void                       CDVFSSIBot::DrawSLC(const long _chart_id, const string _name_prefix, const datetime _dt, const double _price, const color _clr);
  void                       CDVFSSIBot::Draw();
    
  void                       CDVFSSIBot::ParseNews(const string _str, string& _arr[]);
  void                       CDVFSSIBot::LoadNewsFromFile(const string file_name, string& _arr[]);
  bool                       CDVFSSIBot::LoadNews();
  
  bool                       CDVFSSIBot::ParseSymStr(const string _str, CArrayString& _arr);
};

//+------------------------------------------------------------------+
//| Destructor
//+------------------------------------------------------------------+
void CDVFSSIBot::~CDVFSSIBot(void){
  string sym[];
  CSymSet* set[];
  if(SymSetHash.CopyTo(sym, set) > 0)
    for(int i=0;i<ArraySize(sym);i++) {
      IndicatorRelease(set[i].IndSLCHndl);      
      delete set[i];
    }
}


//+------------------------------------------------------------------+
//| Inits bot
//+------------------------------------------------------------------+
void CDVFSSIBot::InitChild() {
  // Put code here
  
  StopLossDT = 0;
  
  // 01. Load news
  NewsNextUpdateDT = 0;
  NewsLastDT = 0;
  NewsHugeBarStopTradeDT = 0;
  ParseNews(Inputs.FIL_NWS_NAM, NewsNamesArr);
  LoadNewsFromFile(NEWS_FILENAME, NewsNamesArr);
  LoadNews(); 
  
  // 02. Parse sym by week day
  ParseSymStr(Inputs.SET_SYM_SUN, WeekDaySym[0]);
  ParseSymStr(Inputs.SET_SYM_MON, WeekDaySym[1]);
  ParseSymStr(Inputs.SET_SYM_TUE, WeekDaySym[2]);
  ParseSymStr(Inputs.SET_SYM_WED, WeekDaySym[3]);
  ParseSymStr(Inputs.SET_SYM_THU, WeekDaySym[4]);
  ParseSymStr(Inputs.SET_SYM_FRI, WeekDaySym[5]);
  ParseSymStr(Inputs.SET_SYM_SAT, WeekDaySym[6]);
  
  // 03. Parse setup type by week day
  WeekDaySetup[0] = Inputs.SET_TYP_SUN;
  WeekDaySetup[1] = Inputs.SET_TYP_MON;
  WeekDaySetup[2] = Inputs.SET_TYP_TUE;
  WeekDaySetup[3] = Inputs.SET_TYP_WED;
  WeekDaySetup[4] = Inputs.SET_TYP_THU;
  WeekDaySetup[5] = Inputs.SET_TYP_FRI;
  WeekDaySetup[6] = Inputs.SET_TYP_SAT;
  
  // 04. Parse time by week day
  WeekDayTime[0].Init(Inputs.FIL_TIM_SUN);
  WeekDayTime[1].Init(Inputs.FIL_TIM_MON);
  WeekDayTime[2].Init(Inputs.FIL_TIM_TUE);
  WeekDayTime[3].Init(Inputs.FIL_TIM_WED);
  WeekDayTime[4].Init(Inputs.FIL_TIM_THU);
  WeekDayTime[5].Init(Inputs.FIL_TIM_FRI);
  WeekDayTime[6].Init(Inputs.FIL_TIM_SAT);  
  
  Status = UNKNOWN;
  
  // Init SLC ind 
  for(int i=0;i<ArraySize(WeekDaySym);i++){
    CDKArrayString sym_arr = WeekDaySym[i];       
    for(int j=0;j<sym_arr.Total();j++){
      string sym = sym_arr.At(j);      
      if(SymSetHash.ContainsKey(sym)) continue;
      
      CSymSet* set = new CSymSet;
      set.Sym = sym;
      set.IndSLCHndl = iCustom(sym, TF, "FXSSI.com//FXSSI.StopLossClusters");

      SymSetHash.Add(sym, set);
    }
  } 
  
  // Open charts
  if(Inputs._GUI_ENB) {
    string sym[];
    CSymSet* set[];
    if(SymSetHash.CopyTo(sym, set) > 0)
      for(int i=0;i<ArraySize(sym);i++) 
        if(sym[i] != Sym.Name()) {
          if(!IsChartOpen(set[i].ChartID)) {
            CChart chart;
            set[i].ChartID = chart.Open(sym[i], TF);
            chart.Detach();
          }
        }
        else
          set[i].ChartID = 0;
  }
   
  OnBar();
}

//+------------------------------------------------------------------+
//| Check bot's params
//+------------------------------------------------------------------+
bool CDVFSSIBot::Check(void) {
  if(!CDKBaseBot<CDVFSSIBotInputs>::Check())
    return false;
    
  if(Inputs.GLB_BOT_MODE == EXPORT_NEWS_TO_FILE)
    return false;
    
  if(!Inputs.InitAndCheck()) {
    Logger.Critical(Inputs.LastErrorMessage, true);
    return false;
  }
  
  // Put your additional checks here
  
  // 01. Check Ind loaded success
  string sym[];
  CSymSet* set[];
  SymSetHash.CopyTo(sym, set);
  for(int i=0;i<ArraySize(sym);i++)
    if(set[i].IndSLCHndl == INVALID_HANDLE){
      Logger.Critical(StringFormat("Ошибка запуска SLC индикатора для %s", sym[i]), true);
      return false;
    }
    
  // 02. Check No SINGLE setup
  for(int i=0;i<ArraySize(WeekDaySetup);i++)
    if(WeekDaySetup[i] == SINGLE) {
      Logger.Critical("Сетап SIGNLE еще не разработан", true);
      return false;
    }     
  
  return true;
}

//+------------------------------------------------------------------+
//| OnDeinit Handler
//+------------------------------------------------------------------+
void CDVFSSIBot::OnDeinit(const int reason) {
}

//+------------------------------------------------------------------+
//| OnTick Handler
//+------------------------------------------------------------------+
void CDVFSSIBot::OnTick(void) {
  CDKBaseBot<CDVFSSIBotInputs>::OnTick(); // Check new bar and show comment
  
  // 03. Channels update
  bool need_update = false;
  
  ENUM_BOT_STATUS new_status = OpenOnSignal();
  if(new_status != Status) {
    Status = new_status;
    need_update = true;
  }

  // 06. Update comment
  if(need_update)
    UpdateComment(true);
}

//+------------------------------------------------------------------+
//| OnBar Handler
//+------------------------------------------------------------------+
void CDVFSSIBot::OnBar(void) {
  LoadNews();
  UpdateSLCOfAllSymbols();
  Draw();
  UpdateComment(true);
}

//+------------------------------------------------------------------+
//| OnTrade Handler
//+------------------------------------------------------------------+
void CDVFSSIBot::OnTrade(void) {
  CDKBaseBot<CDVFSSIBotInputs>::OnTrade();
}

//+------------------------------------------------------------------+
//| OnTimer Handler
//+------------------------------------------------------------------+
void CDVFSSIBot::OnTimer(void) {
  CDKBaseBot<CDVFSSIBotInputs>::OnTimer();
  UpdateComment();
}

//+------------------------------------------------------------------+
//| OnTester Handler
//+------------------------------------------------------------------+
double CDVFSSIBot::OnTester(void) {
  return 0;
}

//+------------------------------------------------------------------+
//| On pos SL
//+------------------------------------------------------------------+
void CDVFSSIBot::OnPositionStopLoss(ulong _position, ulong _deal) {
  datetime dt_curr = TimeCurrent();
  datetime dt_from = TimeBeginning(dt_curr, DATETIME_PART_DAY);
  if(!HistorySelect(dt_from, dt_curr))
    return;

  for(int cnt=HistoryDealsTotal()-1; cnt>=0; cnt--){
    ulong ticket = HistoryDealGetTicket(cnt);
    ulong magic = HistoryDealGetInteger(ticket, DEAL_MAGIC);
    string sym = HistoryDealGetString(ticket, DEAL_SYMBOL);
    if(magic == Inputs._MS_MGC) {
      Status = STOP_AFTER_SL;
      StopLossDT = dt_curr;
      LSF_INFO(StringFormat("SYM=%s; TICKET=%I64u; DEAL=%I64u", sym, _position, _deal));
      UpdateComment(true);      
      return;
    }
  }  
}



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//| Bot's logic
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


//+------------------------------------------------------------------+
//| Check chart by ID is open
//+------------------------------------------------------------------+
bool CDVFSSIBot::IsChartOpen(const long _chart_id) {
  if(_chart_id < 0) return false;
  if(_chart_id == 0) return true;
  
  long curr_id = ChartFirst();
  while(curr_id > 0) {
    if(curr_id == _chart_id) return true;
    curr_id = ChartNext(curr_id);
  }    

  return false;
}


//+------------------------------------------------------------------+
//| Updates comment
//+------------------------------------------------------------------+
void CDVFSSIBot::UpdateComment(const bool _ignore_interval = false) {
  ClearComment();

  datetime dt_curr = TimeCurrent();
  color clr_status = (Status > 0) ? clrPink : clrLightGreen;
  AddCommentLine(StringFormat("Время ДЦ: %s %s", WeekDayShortNameRU[TimeToWeekDay(dt_curr)], TimeToString(dt_curr)), 0, clr_status);
  AddCommentLine(StringFormat("Статус: %s", EnumToString(Status)), 0, clr_status);
  AddCommentLine(" ");

  if(Inputs.FIL_NWS_ENB && Calendar.GetAmount() > 0) {
    int max_cnt = 3;
    AddCommentLine(StringFormat("Сегодняшние новости (%d):", max_cnt));
    int cnt = 0;
    for(int i=0;i<Calendar.GetAmount();i++)
      if(TimeBeginning(Calendar[i].time, DATETIME_PART_DAY) == TimeBeginning(dt_curr, DATETIME_PART_DAY)){         
         
        AddCommentLine(StringFormat("  %s: %s", TimeToString(Calendar[i].time), Calendar[i].Name[]));
        cnt++;
        if(cnt >= max_cnt) break;
      }
  }
  

  
//  for(int i=0;i<SetupArr.Total();i++) {
//    CSetupParam* setup = SetupArr.At(i);
//    
//    AddCommentLine(" ");
//    AddCommentLine(StringFormat("#%d - %s:", i+1, setup.Sym.Name()));
//    AddCommentLine(StringFormat("  ↑↑: %s", setup.ParamL.ToString()), clrGreen);
//    AddCommentLine(StringFormat("  ↓↓: %s", setup.ParamS.ToString()), clrRed);
//    for(int j=0;j<setup.WORKTIME.Total();j++) {
//      CTimeInterval* ti = setup.WORKTIME.At(j);
//      AddCommentLine(StringFormat("  Time%s: %s-%s", 
//                                  !setup.WORKTIME.Total() ? IntegerToString(j+1) : "",
//                                  TimeToString(ti.From, TIME_MINUTES | TIME_SECONDS),
//                                  TimeToString(ti.To, TIME_MINUTES | TIME_SECONDS)));  
//    }
//    if(setup.OpenVolume.Volume > 0.0) {
//      color clrBg = (setup.OpenVolume.Dir == BUY) ? clrLightGreen : clrPink; 
//      AddCommentLine(StringFormat("  Volume: %s / %0.2f / %I64u", 
//                                  PosTypeDKToString(setup.OpenVolume.Dir), setup.OpenVolume.Volume, setup.OpenVolume.Ticket),
//                     0, clrBg);
//      AddCommentLine(StringFormat("          %s", 
//                                  TimeToString(setup.OpenVolume.Time, TIME_DATE | TIME_MINUTES | TIME_SECONDS)),
//                     0, clrBg);                     
//    }
//  }

  ShowComment(_ignore_interval);     
}

//+------------------------------------------------------------------+
//| Get Signal
//+------------------------------------------------------------------+
int CDVFSSIBot::GetSignal(const string _sym) {
  CDKSymbolInfo sym;
  if(!sym.Name(_sym)) return 0;
  if(!sym.RefreshRates()) return 0;
  
  string dt_str = IntegerToString(Sym.PriceToPoints(Sym.GetPriceToOpen(POSITION_TYPE_BUY)));
  int num = 0;
  for(int i=StringLen(dt_str)-1;i>=0;i--){
    num = (int)StringToInteger(StringSubstr(dt_str, i, 1));  
    if(num != 0) break;
  }
  if(num <= 3) return 0;
  return ((num % 2) == 0) ? +1 : -1;
}

//+------------------------------------------------------------------+
//| Mock Levels
//+------------------------------------------------------------------+
void CDVFSSIBot::MockLevels(CSymSet* _set, const double _price_close, const string _sym, const double _price_long, const double _price_short) {
  if(_set.Sym == _sym) {
    if(_price_long  > 0) _set.SLC_U = _price_long;
    if(_price_short > 0) _set.SLC_D = _price_short;

    _set.SLC_Dir = 0;
    //if(_set.SLC_U > 0 && _price_close > _set.SLC_U) _set.SLC_Dir = -1;
    //if(_set.SLC_D > 0 && _price_close < _set.SLC_D) _set.SLC_Dir = +1;    
    
    LSF_DEBUG(StringFormat("MOCK SLC: SYM=%s; DIR[0]=%d; C[0]=%f; UP=%f; DOWN=%f", 
                           _set.Sym, 
                           _set.SLC_Dir, _price_close, 
                           _set.SLC_U, _set.SLC_D));      
  }
}

//+------------------------------------------------------------------+
//| Update SLC for set
//+------------------------------------------------------------------+
int CDVFSSIBot::UpdateSLC(CSymSet* _set) {
  uint start = GetTickCount();
  _set.SLC_Dir = 0;
  _set.SLC_DT = TimeCurrent();
  
  if(_set.IndSLCHndl == INVALID_HANDLE) return 0;
  
  double slc_u_buf[]; ArraySetAsSeries(slc_u_buf, true);
  double slc_d_buf[]; ArraySetAsSeries(slc_d_buf, true);
  double close_buf[]; ArraySetAsSeries(close_buf, true);
  if(CopyBuffer(_set.IndSLCHndl, 12, 0, Inputs.GLB_SLC_DPT, slc_u_buf) < (int)Inputs.GLB_SLC_DPT ||
     CopyBuffer(_set.IndSLCHndl, 13, 0, Inputs.GLB_SLC_DPT, slc_d_buf) < (int)Inputs.GLB_SLC_DPT ||
     CopyClose(_set.Sym, TF, 1, 1, close_buf) <= 0) {
    LSF_ERROR(StringFormat("CopyBuffer() Error: SYM=%s; TIME_MS=%d", _set.Sym, GetTickCount()-start));
    return 0;
  }
    
  int slc_u_idx = ArrayFindFirstConditional(slc_u_buf, true, 0.0, COMPARE_TYPE_GT, true, DBL_MAX, COMPARE_TYPE_LT);
  int slc_d_idx = ArrayFindFirstConditional(slc_d_buf, true, 0.0, COMPARE_TYPE_GT, true, DBL_MAX, COMPARE_TYPE_LT);
  
  if(slc_u_idx >= 0) _set.SLC_U = slc_u_buf[slc_u_idx];
  if(slc_d_idx >= 0) _set.SLC_D = slc_d_buf[slc_d_idx];
  
  //if(_set.SLC_U > 0 && close_buf[0] > _set.SLC_U) _set.SLC_Dir = -1;
  //if(_set.SLC_D > 0 && close_buf[0] < _set.SLC_D) _set.SLC_Dir = +1;
    
  LSF_DEBUG(StringFormat("SYM=%s; DIR[0]=%d; C[0]=%f; UP[%d]=%f; DOWN[%d]=%f; TIME_MS=%d", 
                         _set.Sym, 
                         _set.SLC_Dir, close_buf[0], 
                         slc_u_idx, _set.SLC_U, slc_d_idx, _set.SLC_D,
                         GetTickCount()-start));  
                         
  // Mock levels' prices
  MockLevels(_set, close_buf[0], Inputs._MS_MOC_SYM_1, Inputs._MS_MOC_LNG_1, Inputs._MS_MOC_SHT_1);
  MockLevels(_set, close_buf[0], Inputs._MS_MOC_SYM_2, Inputs._MS_MOC_LNG_2, Inputs._MS_MOC_SHT_2);
                      
  return _set.SLC_Dir;
}

//+------------------------------------------------------------------+
//| Check SLC break for set
//+------------------------------------------------------------------+
int CDVFSSIBot::CheckSLCBreak(CSymSet* _set) {
  CDKSymbolInfo sym;
  if(!sym.Name(_set.Sym)) return 0;
  if(!sym.RefreshRates()) return 0;
  
  double bid = sym.Bid();
  if(_set.SLC_U > 0 && bid > _set.SLC_U) _set.SLC_Dir = -1;
  if(_set.SLC_D > 0 && bid < _set.SLC_D) _set.SLC_Dir = +1;
    
  LSF_DEBUG(StringFormat("SYM=%s; DIR[0]=%d; BID=%f; UP=%f; DOWN=%f", 
                         _set.Sym, 
                         _set.SLC_Dir, bid, 
                         _set.SLC_U, _set.SLC_D));  
                         
  return _set.SLC_Dir;
}


//+------------------------------------------------------------------+
//| Update SLC Of All Symbols
//+------------------------------------------------------------------+
void CDVFSSIBot::UpdateSLCOfAllSymbols() {
  datetime dt_curr = TimeCurrent();
  uint wd_curr = TimeToWeekDay(dt_curr);
  CArrayString sym_list = WeekDaySym[wd_curr];
  
  CSymSet* set;
  for(int i=0;i<sym_list.Total();i++) {
    if(!SymSetHash.TryGetValue(sym_list.At(i), set)) return;
    UpdateSLC(set);
  }
}

//+------------------------------------------------------------------+
//| Get Signal for Combined Setup
//+------------------------------------------------------------------+
int CDVFSSIBot::GetSignal_Combined(CArrayString& _sym_arr) {
  CSymSet* set;
  
  // 01. Update all sym SLC lev and hits
  for(int i=0;i<_sym_arr.Total();i++) {
    if(!SymSetHash.TryGetValue(_sym_arr.At(i), set)) return 0;
    CheckSLCBreak(set);
  }

  // 02. Check all sym level are swept
  int dir_0 = 0;
  string sym_0 = "";
  for(int i=0;i<_sym_arr.Total();i++) {
    if(!SymSetHash.TryGetValue(_sym_arr.At(i), set)) return 0;

    if(set.SLC_Dir == 0) return 0;
    if(i==0) { 
      dir_0 = set.SLC_Dir;
      sym_0 = set.Sym;
    }
    if(i > 0 && set.SLC_Dir != dir_0) {
      LSF_DEBUG(StringFormat("SYM_SLC_DIR(%s)=%d != SYM_SLC_DIR(%s)=%d", 
                             sym_0, dir_0, set.Sym, set.SLC_Dir));
      return 0;
    }      
  }  
  
  return dir_0;  
}

//+------------------------------------------------------------------+
//| Enter Pos
//+------------------------------------------------------------------+
ulong CDVFSSIBot::EnterPos(const string _sym, const int _dir, const ENUM_SETUP_TYPE _setup) {
  ENUM_POSITION_TYPE dir = (_dir > 0) ? POSITION_TYPE_BUY: POSITION_TYPE_SELL;

  CDKSymbolInfo sym;
  if(!sym.Name(_sym)) return 0;
  if(!sym.RefreshRates()) return 0;
  
  double ep = sym.GetPriceToOpen(dir);
  uint sl_dist = Inputs.ENT_SL_PNT;
  double sl = sym.AddToPrice(dir, ep, -1*sl_dist);
  uint tp_dist = (uint)(sl_dist*Inputs.ENT_TP_RR);
  double tp = sym.AddToPrice(dir, ep, tp_dist);
  
  // Check min TP dist 'ENT_TP_MNP'
  if(Inputs.FIL_TP_MIN > 0 && tp_dist < Inputs.FIL_TP_MIN) return 0;
  
  double lot = CalculateLotSuper(_sym, Inputs.ENT_MM_TYP, Inputs.ENT_MM_VAL, ep, sl);
  string comment = StringFormat("%s_%s", Logger.Name, EnumToString(_setup));
  
  ulong ticket = 0;
  if(dir == POSITION_TYPE_BUY) 
    ticket = Trade.Buy(lot, _sym, ep, sl, tp, comment);
  else
    ticket = Trade.Sell(lot, _sym, ep, sl, tp, comment);
    
  if(ticket > 0) {
    string msg = StringFormat("Бот %s открыл %s в %s #%I64u объемом %0.2f по сетапу %s",
                              Logger.Name, _sym, PositionTypeToString(dir), ticket, lot, EnumToString(_setup));
    if(Inputs._NOT_ALR_ENB) 
      Alert(msg);
      
    if(Inputs._NOT_PUS_ENB)
      SendNotification(msg);
  }
  
  LSF_ASSERT(ticket > 0,
             StringFormat("TICKET=%I64u; SYM=%s; RET_CODE=%d; DIR=%s; LOT=%0.2f; SETUP=%s; MSG='%s'",
                          ticket, _sym, 
                          Trade.ResultRetcode(),
                          PositionTypeToString(dir), lot, EnumToString(_setup),
                          Trade.ResultRetcodeDescription()
                         ),
             WARN, ERROR);
  
  return ticket;
}

//+------------------------------------------------------------------+
//| Place Order
//+------------------------------------------------------------------+
ulong CDVFSSIBot::PlaceOrder(CSymSet* _set) {
  ENUM_POSITION_TYPE dir = (_set.SLC_Dir > 0) ? POSITION_TYPE_BUY: POSITION_TYPE_SELL;
  ENUM_ORDER_TYPE order_type = (_set.SLC_Dir > 0) ? ORDER_TYPE_BUY_LIMIT : ORDER_TYPE_SELL_LIMIT;
  double slc_price = (_set.SLC_Dir > 0) ? _set.SLC_D : _set.SLC_U;

  CDKSymbolInfo sym;
  if(!sym.Name(_set.Sym)) return 0;
  if(!sym.RefreshRates()) return 0;
  
  double ep = sym.GetPriceToOpen(dir);
  ep = sym.AddToPrice(dir, ep, -1*Inputs.ENT_PO_SHT);
  
  uint sl_dist = Inputs.ENT_SL_PNT;
  double sl = sym.AddToPrice(dir, ep, -1*sl_dist);
  
  uint tp_dist = 0;
  if(Inputs.ENT_TP_TYP == FIXED_PNT) tp_dist = Inputs.ENT_TP_PNT;
  if(Inputs.ENT_TP_TYP == FIXED_RR) tp_dist = (uint)(sl_dist*Inputs.ENT_TP_RR);
  if(Inputs.ENT_TP_TYP == OPPOSITE_SLC) tp_dist = sym.PriceToPoints(MathAbs(ep - ((_set.SLC_Dir > 0) ? _set.SLC_D : _set.SLC_U)));
  double tp = sym.AddToPrice(dir, ep, tp_dist);
  
  // Check min TP dist 'ENT_TP_MNP'
  if(Inputs.FIL_TP_MIN > 0 && tp_dist < Inputs.FIL_TP_MIN) return 0;
  
  double lot = CalculateLotSuper(_set.Sym, Inputs.ENT_MM_TYP, Inputs.ENT_MM_VAL, ep, sl);
  datetime expiration = (Inputs.ENT_PO_EXP > 0) ? TimeCurrent() + Inputs.ENT_PO_EXP : 0;
  string comment = StringFormat("%s_%s", Logger.Name, EnumToString(COMBINED));
  
  ulong ticket = Trade.OrderOpen(_set.Sym, order_type, lot, 0.0, ep, sl, tp, ORDER_TIME_SPECIFIED, expiration, comment);

  if(ticket > 0) {
    string msg = StringFormat("Бот %s разместил LIMIT ордер %s в %s #%I64u объемом %0.2f по сетапу %s",
                              Logger.Name, _set.Sym, PositionTypeToString(dir), ticket, lot, EnumToString(COMBINED));
    if(Inputs._NOT_ALR_ENB) 
      Alert(msg);
      
    if(Inputs._NOT_PUS_ENB)
      SendNotification(msg);
  }
  
  LSF_ASSERT(ticket > 0,
             StringFormat("TICKET=%I64u; SYM=%s; RET_CODE=%d; DIR=%s; LOT=%0.2f; SETUP=%s; MSG='%s'",
                          ticket, _set.Sym, 
                          Trade.ResultRetcode(),
                          PositionTypeToString(dir), lot, EnumToString(COMBINED),
                          Trade.ResultRetcodeDescription()
                         ),
             WARN, ERROR);
  
  return ticket;
}

//+------------------------------------------------------------------+
//| Open On Signal for Single Setup
//+------------------------------------------------------------------+
ENUM_OPEN_POS_RETCODE CDVFSSIBot::OpenOnSignal_Single(const string _sym) {
  datetime dt_curr = TimeCurrent();
  
  // 01. Huge bar after news filter
  if(TimeBeginning(dt_curr, DATETIME_PART_DAY) == TimeBeginning(NewsLastDT, DATETIME_PART_DAY)) {
    MqlRates rates[]; ArraySetAsSeries(rates, true);
    CopyRates(_sym, Inputs.FIL_NWS_STF, NewsLastDT+Inputs.FIL_NWS_AMN*60, NewsLastDT, rates);
    for(int i=0;i<ArraySize(rates);i++){
      uint bar_size_pnt = PriceToPoints(_sym, rates[i].high - rates[i].low);
      if(bar_size_pnt >= Inputs.FIL_NWS_SBS) 
        return FILTERED_NEWS_HUGE_BAR;
    }
  }

  // 02. Filter enter if pos in market
  CDKPositionInfo pos;
  int pos_cnt = PositionsTotal();
  for(int i=0;i<pos_cnt;i++) {
    if(!pos.SelectByIndex(i)) continue;
    if(pos.Symbol() != _sym) continue;
    
    return FILTERED_POS_IN_MARKET;
  }
  
  // 03. Get Signal
  int sig_dir = GetSignal(_sym);
  if(sig_dir == 0) return NO_SIGNAL;

  // 04. Open Pos  
  ulong ticket = EnterPos(_sym, sig_dir, SINGLE);
  if(ticket != 0)
    return SUCCESS;
 
  return TRADE_ERROR;    
}

//+------------------------------------------------------------------+
//| Open On Signal for Combined Setup
//+------------------------------------------------------------------+
ENUM_OPEN_POS_RETCODE CDVFSSIBot::OpenOnSignal_Combined(CArrayString& _sym_arr) {
  datetime dt_curr = TimeCurrent();
  
  // 01. Get Signal
  int sig_dir = GetSignal_Combined(_sym_arr);
  if(sig_dir == 0) return NO_SIGNAL;

  // 02. Open Poses
  bool res = true;
  for(int i=0;i<_sym_arr.Total();i++) {
    CSymSet* set = NULL;
    if(SymSetHash.TryGetValue(_sym_arr.At(i), set)) {
      ulong ticket = PlaceOrder(set);
      if(ticket <= 0) res = false;
    }
  }  
   
  return res ? SUCCESS : TRADE_ERROR;    
}


//+------------------------------------------------------------------+
//| Open On Signal
//+------------------------------------------------------------------+
ENUM_BOT_STATUS CDVFSSIBot::OpenOnSignal() {
  // 01. Get Setup type to trade
  datetime dt_curr = TimeCurrent();
  uint wd_curr = TimeToWeekDay(dt_curr);
  ENUM_SETUP_TYPE setup = WeekDaySetup[wd_curr];
  CArrayString sym_list = WeekDaySym[wd_curr];
  STimeInt time = WeekDayTime[wd_curr];
  
  // 02. Filter time
  if(!time.IsFree())
    if(!time.IsTimeIn(dt_curr)) {
      ExitMarket();
      return STOP_TIME_NOT_ALLOWED;
    }
      
  // 03. SL stop Trading
  if(TimeBeginning(dt_curr, DATETIME_PART_DAY) == TimeBeginning(StopLossDT, DATETIME_PART_DAY))
    return STOP_AFTER_SL;
    
  //04. Huge bar detected stop Trading
  if(TimeBeginning(dt_curr, DATETIME_PART_DAY) != TimeBeginning(NewsHugeBarStopTradeDT, DATETIME_PART_DAY)) {
    if(TimeBeginning(dt_curr, DATETIME_PART_DAY) == TimeBeginning(NewsLastDT, DATETIME_PART_DAY)) {
      for(int i=0;i<sym_list.Total();i++) {
        string sym = sym_list.At(i);
        MqlRates rates[]; ArraySetAsSeries(rates, true);
        CopyRates(sym, Inputs.FIL_NWS_STF, NewsLastDT+Inputs.FIL_NWS_AMN*60, NewsLastDT, rates);
        for(int j=0;j<ArraySize(rates);j++){
        
          // Skip bars of not curr day
          if(TimeBeginning(dt_curr, DATETIME_PART_DAY) != TimeBeginning(rates[j].time, DATETIME_PART_DAY))
            continue;
            
          uint bar_size_pnt = PriceToPoints(sym, rates[j].high - rates[j].low);
          if(bar_size_pnt >= Inputs.FIL_NWS_SBS) {
            NewsHugeBarStopTradeDT = dt_curr;
            return STOP_AFTER_HUGE_BAR_ON_NEWS;
          }
        }
      }
    }       
  }
  else
    return STOP_AFTER_HUGE_BAR_ON_NEWS;
    
  // 05. Filter news time 
  if(Inputs.FIL_NWS_ENB) {
    for(int i=0;i<Calendar.GetAmount();i++){
      datetime dt_news = Calendar[i].time;
      if(dt_curr >= dt_news+Inputs.FIL_NWS_BMN*60 && dt_curr <= dt_news+Inputs.FIL_NWS_AMN*60) {
        ExitMarket();
        NewsLastDT = dt_news;
        return STOP_ON_NEWS_TIME;
      }
    }      
  }
  
  // 06. Orders in market
  COrderInfo order;
  int order_cnt = OrdersTotal();
  for(int i=0;i<order_cnt;i++) {
    if(!order.SelectByIndex(i)) continue;
    if(order.Magic() == Inputs._MS_MGC)    
      return TRACKING_ORDER;
  }
  
  // 07. Filter enter if pos in market
  CDKPositionInfo pos;
  int pos_cnt = PositionsTotal();
  for(int i=0;i<pos_cnt;i++) {
    if(!pos.SelectByIndex(i)) continue;
    if(pos.Magic() == Inputs._MS_MGC)    
      return TRACKING_POS;
  }
      
  //// 06. Open pos
  //if(setup == SINGLE) {
  //  for(int i=0;i<sym_list.Total();i++) {
  //    string sym = sym_list.At(i);       
  //    ENUM_OPEN_POS_RETCODE res = OpenOnSignal_Single(sym);
  //    LSF_INFO(StringFormat("RES=%s; MODE=%s; SYM=%s", EnumToString(res), EnumToString(setup), sym));
  //  }  
  //}
  
  if(setup == COMBINED) {
    ENUM_OPEN_POS_RETCODE res = OpenOnSignal_Combined(sym_list);
    if(res <= 0){
      LSF_INFO(StringFormat("RES=%s; MODE=%s", EnumToString(res), EnumToString(setup)));
    }
    else
      LSF_DEBUG(StringFormat("RES=%s; MODE=%s", EnumToString(res), EnumToString(setup)));
    if(res <= 0) return TRACKING_ORDER;
  }  
  
  return WAITING_SIGNAL;
} 

void CDVFSSIBot::DrawSLC(const long _chart_id, const string _name_prefix, const datetime _dt, const double _price, const color _clr) {
  string name = StringFormat("%s_%s", _name_prefix, TimeToString(_dt));
  
  CChartObjectText dot;
  dot.Create(_chart_id, name, 0, _dt, _price);
  dot.Anchor(ANCHOR_CENTER);
  dot.Description("—");
  dot.Color(_clr);
  dot.Detach();
}

void CDVFSSIBot::Draw() {
  if(!Inputs._GUI_ENB) return;

  string sym[];
  CSymSet* set[];
  if(SymSetHash.CopyTo(sym, set) > 0)
    for(int i=0;i<ArraySize(sym);i++){
      if(set[i].ChartID < 0) continue;
      
      DrawSLC(set[i].ChartID, StringFormat("%s_U", Logger.Name), set[i].SLC_DT, set[i].SLC_U, clrGreen);
      DrawSLC(set[i].ChartID, StringFormat("%s_D", Logger.Name), set[i].SLC_DT, set[i].SLC_D, clrRed);
    }
}

//+------------------------------------------------------------------+
//| Parse News
//+------------------------------------------------------------------+
void CDVFSSIBot::ParseNews(const string _str, string& _arr[]) { 
  CDKString str;
  str.Assign(_str);
  
  CArrayString arr;
  str.Split(";", arr);
  
  ArrayResize(_arr, arr.Total());
  for(int i=0;i<arr.Total();i++) {
    string text = arr.At(i);
    StringTrimLeft(text);
    StringTrimRight(text);
    _arr[i] = text; 
  }
}

//+------------------------------------------------------------------+
//| Load news from file
//+------------------------------------------------------------------+
void CDVFSSIBot::LoadNewsFromFile(const string file_name, string& _arr[]) {
  int file_handle = FileOpen(file_name, FILE_READ | FILE_TXT | FILE_ANSI);
  if (file_handle == INVALID_HANDLE)  {
    Print("Ошибка открытия файла: ", file_name, " Код ошибки: ", GetLastError());
    return;
  }
  
  while (!FileIsEnding(file_handle))  {
    string line = FileReadString(file_handle);
    ArrayResize(_arr, ArraySize(_arr)+1);
    _arr[ArraySize(_arr)-1] = line;
  }
  
  FileClose(file_handle);
  
  LSF_INFO(StringFormat("Загружен фильтр новостей из файла: CNT=%d; FILE=%s", ArraySize(_arr), file_name));
  for(int i=0;i<ArraySize(NewsNamesArr);i++)
    LSF_DEBUG(StringFormat("Фильтр новости #%d: %s", i+1, NewsNamesArr[i]));
}


//+------------------------------------------------------------------+
//| Load News
//+------------------------------------------------------------------+
bool CDVFSSIBot::LoadNews() { 
  if(!Inputs.FIL_NWS_ENB) return false;
  if(TimeBeginning(TimeCurrent(), DATETIME_PART_DAY) <= TimeBeginning(NewsNextUpdateDT, DATETIME_PART_DAY)) return false;
  
  ulong tick_start = GetTickCount64();
  if (!MQLInfoInteger(MQL_TESTER)) { 
    if(Inputs.GLB_BOT_MODE == TRADING) {
      datetime dt_from = TimeCurrent();
      datetime dt_to   = TimeCurrent() + Inputs.__MS_NWS_DEL*24*60*60;
      Calendar.Set(NULL, CALENDAR_IMPORTANCE_NONE, dt_from, dt_to); 
      LSF_INFO(StringFormat("Новости календаря MetaQuoets загружены: EVENT_CNT=%d; TIME=%dms", 
                             Calendar.GetAmount(),
                             GetTickCount64()-tick_start));
    }
    else {
      Calendar.Set(NULL, CALENDAR_IMPORTANCE_NONE, 0, 0); 
      Calendar.Save(CALENDAR_FILENAME);
      string msg = StringFormat("Новости календаря MetaQuoets загружены и сохранены в файл: EVENT_CNT=%d; FILE=%s; TIME=%dms", 
                                Calendar.GetAmount(),
                                CALENDAR_FILENAME, 
                                GetTickCount64()-tick_start);
      LSF_INFO(msg);
      Alert(msg);
      Alert("Перезапустите бота в режиме GLB_BOT_MODE='Торговля'");
    }
  }
  else {
    Calendar.Load(CALENDAR_FILENAME);     
    LSF_INFO(StringFormat("Новости календаря MetaQuoets загружены из файла: EVENT_CNT=%d; FILE=%s; TIME=%dms", 
                           Calendar.GetAmount(),
                           CALENDAR_FILENAME,
                           GetTickCount64()-tick_start));
  }    
  
  Calendar.GetPosAfter(TimeCurrent());
  if(ArraySize(NewsNamesArr) > 0) Calendar.FilterByName(NewsNamesArr);
  Calendar.AutoDSTDK();
  
  LSF_INFO(StringFormat("Новости в работе после фильтра: EVENT_CNT=%d", Calendar.GetAmount()));
  for(int i=0;i<Calendar.GetAmount();i++)
    LSF_DEBUG(StringFormat("Новость в работе после фильтра #%d: %s", i, Calendar[i].Name[]));
  
  NewsNextUpdateDT = TimeCurrent() + Inputs.__MS_NWS_DEL*24*60*60;
  
  return Calendar.GetAmount() > 0;
}

//+------------------------------------------------------------------+
//| Parse Symbols by week dayes
//+------------------------------------------------------------------+
bool CDVFSSIBot::ParseSymStr(const string _str, CArrayString& _arr) { 
  _arr.Clear();
  
  CDKString str;
  str.Assign(_str);
  str.Split(";", _arr);
  
  CDKSymbolInfo sym;
  for(int i=0;i<_arr.Total();i++)
    if(!sym.Name(_arr.At(i))) return false;
    
  return true;
}

//+------------------------------------------------------------------+
//| Close all pos
//+------------------------------------------------------------------+
int CDVFSSIBot::CloseAllPos() { 
  int close_cnt = 0;
  CDKPositionInfo pos;
  int i=0;
  while(i < PositionsTotal()){
    if(pos.SelectByIndex(i) && pos.Magic() == Inputs._MS_MGC) {
      bool res = Trade.PositionClose(pos.Ticket());
      LSF_ASSERT(res,
                 StringFormat("TICKET=%I64u; RET_CODE=%d; MSG='%s'",
                              pos.Ticket(),
                              Trade.ResultRetcode(),
                              Trade.ResultRetcodeDescription()),
                 WARN, ERROR);
      if(res) {
        close_cnt++;
        continue;
      }
    }
    
    i++;
  }
  
  return close_cnt;
}

//+------------------------------------------------------------------+
//| Delete All Oreders
//+------------------------------------------------------------------+
int CDVFSSIBot::DeleteAllOrders() { 
  int close_cnt = 0;
  COrderInfo order;
  int i=0;
  while(i < OrdersTotal()){
    if(order.SelectByIndex(i) && order.Magic() == Inputs._MS_MGC) {
      bool res = Trade.PositionClose(order.Ticket());
      LSF_ASSERT(res,
                 StringFormat("TICKET=%I64u; RET_CODE=%d; MSG='%s'",
                              order.Ticket(),
                              Trade.ResultRetcode(),
                              Trade.ResultRetcodeDescription()),
                 WARN, ERROR);
      if(res) {
        close_cnt++;
        continue;
      }
    }
    
    i++;
  }
  
  return close_cnt;
}

//+------------------------------------------------------------------+
//| Close pos and delete Oreders
//+------------------------------------------------------------------+
bool CDVFSSIBot::ExitMarket() { 
  return (CloseAllPos() + DeleteAllOrders()) > 0;
}

//+------------------------------------------------------------------+
//| Close pos on time
//+------------------------------------------------------------------+
int CDVFSSIBot::CloseOnTime() { 
  datetime dt_curr = TimeCurrent();
  uint wd_curr = TimeToWeekDay(dt_curr);
  STimeInt time = WeekDayTime[wd_curr];  
  
  if(time.IsFree()) return 0;
  if(time.IsTimeIn(dt_curr)) return 0;
  
  return CloseAllPos() + DeleteAllOrders();      
}