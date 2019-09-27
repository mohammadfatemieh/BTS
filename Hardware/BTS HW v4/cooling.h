#define ifFired 			return check_fire()
#define ifACpowerlost 		return check_ac()
#define ifHumiHigh 			return check_humi()
#define ifTempHigh 			return check_temp_high()
#define ifTempLow 			return check_temp_low()
if(ifFired)//co chay xay ra
{
	FAN(OFF);
	AIR(OFF);
}
else if(ifACpowerlost)// Mat dien @@
{
	if(ifHumiHigh)//Am qua
	{
		AIR(OFF);
		if(!ifTempHigh)//Mat
		{
			FAN(OFF);
		}
		else if(ifTempHigh)//Nong
		{
			FAN(OFF);//????
		}	
	}
	else if(!ifHumiHigh)//Ko Am
	{
		AIR(OFF);
		if(ifTempLow)//Mat qua
		{
			FAN(OFF);
		}
		else if(!ifTempLow)//Nong VL
		{
			FAN(ON);
		}
	}
}
else if(!ifACpowerlost)// ko Mat dien =))
{
	if(ifHumiHigh)//Am qua
	{
		FAN(OFF);
		if(ifTempHigh)//Nong qua
		{
			AIR(ON);//Chay ca 2 dieu hoa
		}
		if(!ifTempHigh)//Do nong hon ti
		{
			AIR(ON/2);//Chay 1 nua dieu hoa =))
		}
	}
	if(!ifHumiHigh)// Ngon, ko am :3
	{
		if(ifTempHigh)//Nong vd
		{
			AIR(ON);//bat tat dieu hoa len 
		}
		else if(!ifTempHigh)//Do nong hon nhung van nong vd => Nhiet do giam dan
		{
			AIR(ON/2);//Chay luan phien 2 dieu hoa 
		}
		
		if(!ifTempLow)//ko phai mat qua
		{
			AIR(OFF);
			FAN(ON);
		}
		else if(ifTempLow)//Mat qua
		{
			AIR(OFF);
			FAN(OFF);
		}
	}
}
//Kiem tra nhiet do cao
bool check_temp_high(uint16_t temp,uint16_t old_temp)
{
	if(temp>34)// nong vd
	{
		return true;
	}
	else if(temp<32)
	{
		return false;
	}
	else
	{
		if(old_temp>temp) return true;//Nhiet do dang giam
		else if(old_temp>temp) return false;// Nhiet do dang tang
	}
}