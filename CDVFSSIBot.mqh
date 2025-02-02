//+------------------------------------------------------------------+
//|                                                   CDVFSSIBot.mqh |
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

//#include <ChartObjects\ChartObjectsShapes.mqh>
#include <ChartObjects\ChartObjectsLines.mqh>
//#include <ChartObjects\ChartObjectsArrows.mqh> 

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

#include "CDVFSSIInputs.mqh"
#include "CDVFSSISetupParam.mqh"

class CDVFSSIBot : public CDKBaseBot<CDVFSSIBotInputs> {
public: // SETTINGS

protected:
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
  
  // Bot's logic
  void                       CDVFSSIBot::UpdateComment(const bool _ignore_interval = false);

  int                        CDVFSSIBot::GetSignal();
  
  void                       CDVFSSIBot::OpenOnSignal();
  
  void                       CDVFSSIBot::Draw();
};

//+------------------------------------------------------------------+
//| Destructor
//+------------------------------------------------------------------+
void CDVFSSIBot::~CDVFSSIBot(void){
}


//+------------------------------------------------------------------+
//| Inits bot
//+------------------------------------------------------------------+
void CDVFSSIBot::InitChild() {
  // Put code here

  UpdateComment(true);
}

//+------------------------------------------------------------------+
//| Check bot's params
//+------------------------------------------------------------------+
bool CDVFSSIBot::Check(void) {
  if(!CDKBaseBot<CDVFSSIBotInputs>::Check())
    return false;
    
  if(!Inputs.InitAndCheck()) {
    Logger.Critical(Inputs.LastErrorMessage, true);
    return false;
  }
  
  // Put your additional checks here
  
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

  // 06. Update comment
  if(need_update)
    UpdateComment(true);
}

//+------------------------------------------------------------------+
//| OnBar Handler
//+------------------------------------------------------------------+
void CDVFSSIBot::OnBar(void) {
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
  UpdateComment();
  CDKBaseBot<CDVFSSIBotInputs>::OnTimer();
}

//+------------------------------------------------------------------+
//| OnTester Handler
//+------------------------------------------------------------------+
double CDVFSSIBot::OnTester(void) {
  return 0;
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
//| Updates comment
//+------------------------------------------------------------------+
void CDVFSSIBot::UpdateComment(const bool _ignore_interval = false) {
  ClearComment();

//  datetime dt_curr = TimeCurrent();
//  AddCommentLine(StringFormat("Time:   %s", TimeToString(TimeCurrent())));
//  
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
int CDVFSSIBot::GetSignal() {
  int dir = 0;
    
  //LSF_ASSERT(dir != 0,
  //           StringFormat("RES=%d; ZZ_DIR=%d; MODE=%s",
  //                        dir, dir_zz, msg),
  //           INFO, DEBUG);
                               
  return dir;
}



//+------------------------------------------------------------------+
//| Open On Signal
//+------------------------------------------------------------------+
void CDVFSSIBot::OpenOnSignal() {
  
} 


void CDVFSSIBot::Draw() {
  if(!Inputs._GUI_ENB) return;

}

