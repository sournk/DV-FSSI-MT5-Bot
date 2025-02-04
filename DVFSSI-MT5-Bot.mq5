//+------------------------------------------------------------------+
//|                                               DVFSSI-MT5-Bot.mq5 |
//|                                                  Denis Kislitsyn |
//|                                             https://kislitsyn.me |
//+------------------------------------------------------------------+

#property strict
#property script_show_inputs


#include "Include\DKStdLib\Logger\CDKLogger.mqh"
#include "Include\DKStdLib\TradingManager\CDKTrade.mqh"
#include "CDVFSSIBot.mqh"


CDVFSSIBot                      bot;
CDKTrade                        trade;
CDKLogger                       logger;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit(){  
  CDVFSSIBotInputs inputs;
  FillInputs(inputs);
  
  logger.Init(inputs._MS_EGP, inputs._MS_LOG_LL);
  logger.FilterInFromStringWithSep(inputs._MS_LOG_FI, ";");
  logger.FilterOutFromStringWithSep(inputs._MS_LOG_FO, ";");
  
  trade.Init(Symbol(), inputs._MS_MGC, 0, GetPointer(logger));

  bot.CommentEnable                = inputs._MS_COM_EN;
  bot.CommentIntervalSec           = inputs._MS_COM_IS;
  
  bot.Init(Symbol(), Period(), inputs._MS_MGC, trade, inputs._MS_COM_CW, inputs, GetPointer(logger));
  bot.SetFont("Courier New");
  bot.SetHighlightSelection(true);

  if (!bot.Check()) 
    return(INIT_PARAMETERS_INCORRECT);

  if(inputs._MS_TIM_MS >= 1000)
    EventSetTimer(inputs._MS_TIM_MS/1000);
  else
    EventSetMillisecondTimer(inputs._MS_TIM_MS);
  
  return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)  {
  bot.OnDeinit(reason);
  EventKillTimer();
}
  
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()  {
  bot.OnTick();
}

//+------------------------------------------------------------------+
//| Timer function                                                   |
//+------------------------------------------------------------------+
void OnTimer()  {
  bot.OnTimer();
}

//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void OnTrade()  {
  bot.OnTrade();
}

//+------------------------------------------------------------------+
//| TradeTransaction function                                        |
//+------------------------------------------------------------------+
void OnTradeTransaction(const MqlTradeTransaction& trans,
                        const MqlTradeRequest& request,
                        const MqlTradeResult& result) {
  bot.OnTradeTransaction(trans, request, result);
}

double OnTester() {
  return bot.OnTester();
}

void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam) {
  bot.OnChartEvent(id, lparam, dparam, sparam);                                    
}

