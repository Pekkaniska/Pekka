
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	Если ТипЗнч(ПараметрКоманды) = Тип("Массив") И Не ПараметрКоманды.Количество()=0 Тогда 
		уатГСМ.ПакетныйВводСливовГСМ(ПараметрКоманды);
	КонецЕсли;
	
КонецПроцедуры
