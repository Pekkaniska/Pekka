
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	ОбработкаКомандыСервер(ПараметрКоманды);
КонецПроцедуры

&НаСервере
Процедура ОбработкаКомандыСервер (ПараметрКоманды) 
	пкМобильныеУстройства.пкСоздатьНачальныйОбраз(ПараметрКоманды);
КонецПроцедуры	