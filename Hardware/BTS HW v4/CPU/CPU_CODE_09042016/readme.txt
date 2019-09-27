Thuat toan:
Master Board Turn ON

1. Init hardware
2. Running mode : 
- Operation  & Maintaince 
Operation: Automatic running without any control
Maintaince: Manual control/ setup / maintaince device and station
3.1:Operation
- Update Sensor data: IF HAVE EVENT : Event Flag=1
		+ Humi & Temp on Master
		+ Water + Smoke + Gate on Basic 
		+ AC&DC on Basic
		+ FAN/AIR? Master control => Fan/AIR Respon => Master Know FAN/AIR is work or wrong
- Process (Event Flag)
		+ If(Event1)
		+ If(Event2)
		+ If(Event3)
		
Phan cap bien???
>1XX:[hr][min][date][month][year][ex_humi_H][ex_humi_L][ex_temp_H]
[ex_temp_L][int_Humi_H][int_Humi_L][int_temp_H][int_temp_H][water+smoke+gate+pir+glass][alarm][check_sum]!<
=> Ban tin >101:[][][]..................[][101]!< Tu 01 gui di : Cap nhat thoi gian, nhiet do, do am cho toan bo he thong
=> Ban tin >102:[][][][water+smoke+gate][][102]!< Tu 02 gui di : Cap nhat cac cam bien water+smoke+gate
'>2XX:[hr][min][date][month][year][AC][][][][][][][][][]!<
'>3XX:[hr][][][][][][][][][DC]!<
>4XX:[hr][]][][][][][][][Control]!<

3.2:Maintaince