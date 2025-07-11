
//+------------------------------------------------------------------+
//|                                                      DracoScalp  |
//|      A high-frequency scalper bot for BTCUSD on 5M chart         |
//|      Version: Weekend Edition                                    |
//+------------------------------------------------------------------+
#property strict
input double LotSize = 0.01;
input int TakeProfit = 150;     // 15 pips (scaled for BTC)
input int StopLoss = 100;       // 10 pips (scaled for BTC)
input int Slippage = 3;

int OnInit()
  {
   Print("DracoScalp Initialized");
   return(INIT_SUCCEEDED);
  }

void OnTick()
  {
   double Ask = SymbolInfoDouble(_Symbol, SYMBOL_ASK);
   double Bid = SymbolInfoDouble(_Symbol, SYMBOL_BID);
   datetime time = TimeCurrent();

   if(TimeMinute(time) % 5 == 0 && TimeSeconds(time) < 2)
     {
      if(PositionSelect(_Symbol) == false)
        {
         // Buy if last candle closed bullish
         double close1 = iClose(_Symbol, PERIOD_M5, 1);
         double open1 = iOpen(_Symbol, PERIOD_M5, 1);
         if(close1 > open1)
           {
            trade.Buy(LotSize, _Symbol, Ask, (Ask + TakeProfit * _Point), (Ask - StopLoss * _Point), NULL);
           }
        }
     }
  }
// This is a simplified scalper logic. DracoScalp trades BTCUSD on M5 aggressively.
