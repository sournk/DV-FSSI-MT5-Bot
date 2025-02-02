# DS-AS-PR: Bistrushka / Быструшка
The bot for MetaTrader 5 with "Bistrushka" strategy by Alexander Silaev the author of "Money without fools" book

* Created by Denis Kislitsyn | denis@kislitsyn.me | [kislitsyn.me](https://kislitsyn.me/personal/algo)
* Version: 1.00

![Layout](img/UM003.%20Layout.gif)

## What's new?
```
1.00: First version
```

## Abstract

Советник для MetaTrader 5 торгует пробивную канальную стратегию ['Быструшка'](https://t.me/ASilaev_store/30) Александра Силаева.

Бот может торговать на одном графике несколько сетапов одновременно. Каждый сетап - это правила ценового канала для одного символа, при пробитии которого бот входит в сделки. Верхний и нижний уровни канала могут быть построены на разных ТФ и по разным OHLC ценам свечей. Например, верхний уровень канала можно строить на M5 по хаям 100 последних свечей, а нижний по закрытиям за 50. Также в каждом сетапе должны быть заданы:
1. Временной интервал для входов в позиции.
2. Фиксированное время выхода из позиции.
3. Минимальный отступ закрытия свечи над или под уровнем для входа в позицию.
4. Задержка входа в позицию после пробития канала.
5. Размер позиции.

Бот может торговать один сетап, параметры которого можно задать в стандартном для MT5 диалоговом окне, и 9 сетапов, которые можно задать строкой параметров Quik. 

## Строки инициализации сетапов Quik

Чтобы торговать несколько сетапов одновременно, их нужно задать в формате строк Quik оригинального бота. В каждой строке заданы параметры, разделенные `;`. Формат Quik строки:

```
┌ 01. Символ сетапа
|    ┌ 02. LONG TF
|    |  ┌ 03. LONG Period - количество свечей в канале для верхнего уровня
|    |  |  ┌ 04. Цена свечей верхнего канала
|    |  |  |    ┌ 05. Минимальный пробой канала для входа
|    |  |  |    |       ┌ 06. Задержка входа после пробоя, сек
|    |  |  |    |       |  ┌ 07. Время выхода в формате HH:MM:SS или HH:MM
|    |  |  |    |       |  |        ┌ 08. Лот
|    |  |  |    |       |  |        |
SiH5;M5;70;HIGH;0.00001;10;10:14:50;1;M5;70;LOW;0.00001;10;10:14:50;1;10:15:00-18:44:00
                                      |  |  |   |       |  |        | |
                                      |  |  |   |       |  |        | └ Период входа для сетапа, который перекрывает основной
                                      |  |  |   |       |  |        └ 08. Лот
                                      |  |  |   |       |  └ 14. Время выхода в формате HH:MM:SS или HH:MM
                                      |  |  |   |       └ 13. Задержка входа после пробоя, сек
                                      |  |  |   └ 12. Минимальный пробой канала для входа
                                      |  |  └ 11. Цена свечей нижнего канала
                                      |  └ 10. SHORT Period - количество свечей в канале для нижнего уровня
                                      └ 09. SHORT TF
   L 01: Имя символа
```

Чтобы избежать ошибок при формировании Quik строк можно воспользоваться ботом для их  автоматического создания. Для этого при запуске бота заполните все параметры сетапа в секции `2. SETUP (SET)`.
![2. SETUP (SET)](img/UM001.%20Quik%20Setup.png)
После запуска бот выведет на странице логов `Experts` все заданные параметры в формате Quik строки. Ее можно скопировать и вставить в один из параметров секции `3. QUIK (QUK)`.
![Скопировать Quik строку](img/UM002.%20Quik%20Format.png)


## Installation
1. Make sure that your MetaTrader 5 terminal is updated to the latest version. To test Expert Advisors, it is recommended to update the terminal to the latest beta version. To do this, run the update from the main menu `Help->Check For Updates->Latest Beta Version`. The Expert Advisor may not run on previous versions because it is compiled for the latest version of the terminal. In this case you will see messages on the `Journal` tab about it.
2. Copy the bot executable file `*.ex5` to the terminal data directory `MQL5\Experts`.
3. Open the pair chart.
4. Move the Expert Advisor from the Navigator window to the chart.
5. Check `Allow Auto Trading` in the bot settings.
6. Enable the auto trading mode in the terminal by clicking the `Algo Trading` button on the main toolbar.
7. Load the set of settings by clicking the `Load` button and selecting the set-file.

## Recompilation

1. Start the IDE in MetaTrader 5. Select `Tools\Meta Quotes Language Editor` in the menu.
2. Go to the `Experts\<Expert's Catalogue>` folder.
3. Open the `*.mqproj` file.
4. Select the `Build\Compile` menu item.
5. The terminal will compile a new file `*.ex5` in the same directory.

## Inputs

##### 1. GLOBAL (GLB)
- [x] `GLB_WORKTIME1`: Период времени входов в сделку
- [x] `GLB_WORKTIME2`: Период времени входов в сделку
- [x] `GLB_WORKTIME3`: Период времени входов в сделку

##### 2. SETUP (SET)
- [x] `SET_ENB`: Использовать MT5 сетап
- [x] `L_TIMEFRAME`: (Long) Таймфрейм
- [x] `L_PERIOD`: (Long) Количество свечей канала
- [x] `L_FIELD`: (Long) Поле для расчета канала [Open/High/Low/Close]
- [x] `L_OFFSET`: (Long) Мин превышение для входа
- [x] `L_DELAY`: (Long) Задержка открытия позиции
- [x] `L_CLOSETIME`: (Long) Время закрытия позиции
- [x] `L_SIZE`: (Long) Размер позиции
- [x] `S_TIMEFRAME`: (Long) Таймфрейм
- [x] `S_PERIOD`: (Long) Количество свечей канала
- [x] `S_FIELD`: (Long) Поле для расчета канала [Open/High/Low/Close]
- [x] `S_OFFSET`: (Long) Мин превышение для входа
- [x] `S_DELAY`: (Long) Задержка открытия позиции
- [x] `S_CLOSETIME`: (Long) Время закрытия позиции
- [x] `S_SIZE`: (Long) Размер позиции

##### 3. QUIK (QIK)
- [x] `QUIK_STR1`: Настройка сетапа 1 (пусто-откл)
- [x] `QUIK_STR2`: Настройка сетапа 2 (пусто-откл)
- [x] `QUIK_STR3`: Настройка сетапа 3 (пусто-откл)
- [x] `QUIK_STR3`: Настройка сетапа 4 (пусто-откл)
- [x] `QUIK_STR3`: Настройка сетапа 5 (пусто-откл)
- [x] `QUIK_STR3`: Настройка сетапа 6 (пусто-откл)
- [x] `QUIK_STR3`: Настройка сетапа 7 (пусто-откл)
- [x] `QUIK_STR3`: Настройка сетапа 8 (пусто-откл)
- [x] `QUIK_STR3`: Настройка сетапа 9 (пусто-откл)

##### 5. ГРАФИКА (GUI)
- [x] `GUI_ENB`: Графика включена

##### 6. РАЗНОЕ (MS)
- [x] `MS_MGC`: Expert Adviser ID - Magic 
- [x] `MS_EGP`: Expert Adviser Global Prefix
- [x] `MS_LOG_LL`: Log Level 
- [x] `MS_LOG_FI`: Log Filter IN String (use `;` as sep) 
- [x] `MS_LOG_FO`: Log Filter OUT String (use `;` as sep)
- [x] `MS_COM_EN`: Comment Enable (turn off for fast testing)
- [x] `MS_COM_IS`: Comment Interval, Sec 
- [x] `MS_COM_EW`: Comment Custom Window 
- [x] `MS_TIM_MS`: Timer Interval, ms
- [x] `MS_LIC_DUR_SEC`: License Duration, Sec