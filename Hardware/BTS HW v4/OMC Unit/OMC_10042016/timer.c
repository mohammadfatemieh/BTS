#include "timer.h"
CallbackFuncTypeDef arCallbackFunc[MAXCALLBACKFUNC] = {NULL};
__IO BYTE g_byChangeSecondFlag, g_byChangeTickFlag;
__IO DWORD g_dwTimingDelay = 0;
__IO DWORD g_dwTickcount = 0;
VOID CancelTimer(SYSTEMCALLBACK Callback, PVOID pData)
{
    BYTE i =0;
    if ( pData != NULL )
    {                
        
        for ( i = 0; i < MAXCALLBACKFUNC; i++)
            if ( (arCallbackFunc[i].CallbackFunc == Callback) && (arCallbackFunc[i].pData == pData))
            {
                arCallbackFunc[i].CallbackFunc = NULL;
                arCallbackFunc[i].pData = NULL;
                break;
            }
    }
    else
    {
        for ( i = 0; i < MAXCALLBACKFUNC; i++)
            if (arCallbackFunc[i].CallbackFunc == Callback)
            {
                arCallbackFunc[i].CallbackFunc = NULL;
                arCallbackFunc[i].pData = NULL;
            }
    }
}

BOOL IsRunning (SYSTEMCALLBACK Callback, PVOID pData )
{
    BYTE i =0;
    if (pData != NULL)
    {
        for ( i = 0; i < MAXCALLBACKFUNC; i++)
            if ( (arCallbackFunc[i].CallbackFunc == Callback) && (arCallbackFunc[i].pData == pData))
                return TRUE;
        return FALSE;
    }
    else
    {
        for ( i = 0; i < MAXCALLBACKFUNC; i++)
            if ( arCallbackFunc[i].CallbackFunc == Callback )
                return TRUE;
        return FALSE;
    }
}

VOID  StartShortTimer (WORD wTickCount, SYSTEMCALLBACK Callback, PVOID pData)
{
    BYTE i =0;
    if (Callback == NULL ) return ;

    for ( i = 0 ; i < MAXCALLBACKFUNC; i++)
    {
        if( ((arCallbackFunc[i].CallbackFunc == Callback)&& (arCallbackFunc[i].pData == pData)) ||\
            (arCallbackFunc[i].CallbackFunc == NULL) )
        {
            arCallbackFunc[i].CallbackFunc = Callback;
            arCallbackFunc[i].wTickCount = wTickCount;
            arCallbackFunc[i].nSecondCount = 0;
            arCallbackFunc[i].nState = 1;
            arCallbackFunc[i].pData = pData;
            break;
        }
    }
}

VOID StartLongTimer ( WORD wSecondCount, SYSTEMCALLBACK Callback, PVOID pData )
{
    BYTE i =0;
    if (Callback == NULL ) return ;

    for ( i = 0 ; i < MAXCALLBACKFUNC; i++ )
    {
        if ( ((arCallbackFunc[i].CallbackFunc == Callback) && ( arCallbackFunc[i].pData == pData )) ||\
            (arCallbackFunc[i].CallbackFunc == NULL) )
        {
            arCallbackFunc[i].CallbackFunc = Callback;
            arCallbackFunc[i].wTickCount = 0;
            arCallbackFunc[i].nSecondCount = wSecondCount;
            arCallbackFunc[i].pData = pData;
            arCallbackFunc[i].nState = 1;
            break ;
        }
    }
}

VOID ProcessTimerEvents(VOID)
{
    static SYSTEMCALLBACK CallbackFuncTemp = NULL ;
    static PVOID pData = NULL;
    BYTE i =0;
    if (g_byChangeTickFlag)
    {

        g_byChangeTickFlag = 0;
        for ( i = 0; i < MAXCALLBACKFUNC ; i++ )
        {
            if ( arCallbackFunc[i].wTickCount > 0 ) arCallbackFunc[i].wTickCount --;
        }
    }

    if (g_byChangeSecondFlag)
    {
        g_byChangeSecondFlag = 0;
        for ( i = 0; i < MAXCALLBACKFUNC ; i++ )
        {
            if ( arCallbackFunc[i].nSecondCount > 0 ) arCallbackFunc[i].nSecondCount --;
        }
    }
    for ( i = 0; i < MAXCALLBACKFUNC ; i++)
    {
        if ( arCallbackFunc[i].CallbackFunc != NULL )
        {
            if ( (arCallbackFunc[i].wTickCount == 0) && ( arCallbackFunc[i].nSecondCount == 0 ) &&\
                 (arCallbackFunc[i].nState == 1) )
            {
                CallbackFuncTemp = arCallbackFunc[i].CallbackFunc;
                pData = arCallbackFunc[i].pData;
                arCallbackFunc[i].nSecondCount = 0 ;
                arCallbackFunc[i].wTickCount = 0;
                arCallbackFunc[i].nState = 0 ;
                arCallbackFunc[i].pData = NULL ;
                arCallbackFunc[i].CallbackFunc = NULL;
                CallbackFuncTemp (pData);
            }
        }
    }
}

/*-----------------------------------------*/
DWORD GetTickCount(VOID)
{
    return g_dwTickcount;
}


VOID Delay_ms(__IO DWORD dwTime)
{
  g_dwTimingDelay = dwTime;

  while(g_dwTimingDelay != 0);
}




