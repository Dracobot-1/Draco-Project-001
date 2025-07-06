
//+------------------------------------------------------------------+
//|                                               DracoBot.mq5       |
//|                               Created by Vinnie x Draco (GPT)   |
//|                 Smart Money Concept Sniper Bot for XAUUSD       |
//+------------------------------------------------------------------+
#property strict

input double RiskPercent = 5.0;          // Risk per trade in %
input int Slippage = 3;                  // Max slippage
input int MagicNumber = 777;             // Unique ID for the bot
input double RRRatio = 2.0;              // Risk-Reward Ratio
input ENUM_TIMEFRAMES SignalTF = PERIOD_H1;  // Timeframe for signal

// Global variables
double lotSize, stopLossPoints, takeProfitPoints;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
   Print("DracoBot Initialized: Precision & Discipline Activated.");
   return(INIT_SUCCEEDED);
  }

//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
   Print("DracoBot Shutdown: Gold War Machine Standing Down.");
  }

//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
   if(!IsNewCandle()) return;

   if(PositionSelect(Symbol()) == false)
     {
      double entryPrice = iClose(Symbol(), SignalTF, 1);
      double stopLoss = entryPrice - (100 * _Point); // Example: 100 points below entry
      double takeProfit = entryPrice + ((entryPrice - stopLoss) * RRRatio);

      stopLossPoints = MathAbs(entryPrice - stopLoss);
      takeProfitPoints = MathAbs(takeProfit - entryPrice);
      lotSize = CalculateLotSize(stopLossPoints);

      if(lotSize > 0)
        {
         trade.Buy(lotSize, Symbol(), entryPrice, stopLoss, takeProfit, NULL);
         Print("DracoBot executed trade: Buy ", lotSize, " lots at ", entryPrice);
        }
     }
  }

//+------------------------------------------------------------------+
//| Check for new candle                                             |
//+------------------------------------------------------------------+
bool IsNewCandle()
  {
   static datetime lastCandleTime = 0;
   datetime currentCandleTime = iTime(Symbol(), SignalTF, 0);
   if(currentCandleTime != lastCandleTime)
     {
      lastCandleTime = currentCandleTime;
      return true;
     }
   return false;
  }

//+------------------------------------------------------------------+
//| Calculate lot size based on account balance and stop loss        |
//+------------------------------------------------------------------+
double CalculateLotSize(double slPoints)
  {
   double riskAmount = AccountBalance() * RiskPercent / 100.0;
   double tickValue = SymbolInfoDouble(Symbol(), SYMBOL_TRADE_TICK_VALUE);
   double lotStep = SymbolInfoDouble(Symbol(), SYMBOL_VOLUME_STEP);
   double lotSize = NormalizeDouble(riskAmount / (slPoints / _Point * tickValue), 2);
   lotSize = MathMax(lotSize, lotStep);
   return lotSize;
  }

//+------------------------------------------------------------------+
