
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ЗначенияРеквизитов = ПараметрыВидаРабочегоЦентра(ПараметрКоманды);
	
	Если ЗначенияРеквизитов.ЭтоГруппа Тогда
		ПоказатьПредупреждение(, НСтр("ru='Команда не может быть выполнена для указанного объекта!'"));
		Возврат;
	КонецЕсли;
	
	УчетДоступности = (ЗначенияРеквизитов.ПланироватьРаботу И ЗначенияРеквизитов.УчитыватьДоступностьПоГрафикуРаботы)
		ИЛИ ЗначенияРеквизитов.ПланироватьРаботуРабочихЦентров;
	
	Если НЕ УчетДоступности Тогда
		
		ОчиститьСообщения();
		
		ТекстСообщения = СтрШаблон(
			НСтр("ru = 'Для вида рабочего центра ""%1"" не ведется учет доступности: не учитывается ограничение доступности в графике производства и не планируется работа рабочих центров.'"),
			ЗначенияРеквизитов.Представление);
			
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗначенияРеквизитов.ПланироватьРаботу И ЗначенияРеквизитов.УчитыватьДоступностьПоГрафикуРаботы Тогда
		РежимРаботы = ПредопределенноеЗначение("Перечисление.РежимыРедактированияДоступностиВидовРЦ.ВводДоступностиДляФормированияГрафикаПроизводства");
	Иначе
		РежимРаботы = ПредопределенноеЗначение("Перечисление.РежимыРедактированияДоступностиВидовРЦ.ВводГрафикаРаботыРЦДляФормированияРасписанияРаботыРЦ");
	КонецЕсли;
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("РежимРаботы", РежимРаботы);
	ПараметрыФормы.Вставить("ВидРабочегоЦентра", ПараметрКоманды);
	ПараметрыФормы.Вставить("НачалоПериода", ОбщегоНазначенияКлиент.ДатаСеанса());
	
	ОткрытьФорму(
		"Обработка.ДоступностьВидовРабочихЦентров.Форма",
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
	
КонецПроцедуры

&НаСервере
Функция ПараметрыВидаРабочегоЦентра(Ссылка)
	
	Реквизиты = "ЭтоГруппа,
				|Представление,
				|ПланироватьРаботу,
				|УчитыватьДоступностьПоГрафикуРаботы,
				|ПланироватьРаботуРабочихЦентров";
	
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, Реквизиты);
	
КонецФункции

#КонецОбласти
