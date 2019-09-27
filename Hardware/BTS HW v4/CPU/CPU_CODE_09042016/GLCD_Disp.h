/**
 * @defgroup Device_Typedefs
 * @brief    Library Typedefs
 * @{
 */
#include "TA_Master_HW2_drivers.h"
/**
 * Enumerations
 *
 * There are several different possible status.
 * If TM_AM2301_OK is returned from read function then you have valid data.
 */
typedef enum {
	Idle,						/*!< Data OK */
	Warnings,					/*!< An error occurred */
	Settings,			/*!< Device Settings */
	USB_Connected				/*!< USB_Connected */
} Device_STT;

void GLCD_CONST_RTCSEN (void);
void GLCD_RTCSEN_Update (BTS_RTC temp);