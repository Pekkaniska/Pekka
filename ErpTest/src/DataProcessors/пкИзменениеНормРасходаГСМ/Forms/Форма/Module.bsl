
////////////////////////////////////////////////////////////////////////////////////////////
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Период") Тогда
		Объект.Период = Параметры.Период;
	КонецЕсли;
	
	Если Параметры.Свойство("Подразделение") Тогда
		Объект.Подразделение = Параметры.Подразделение;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	ОповеститьОВыборе("ВыполненаОбработка");
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////////////////
&НаКлиенте
Процедура УстановитьНормы(Команда)
	
	Отказ = Ложь;
	
	Если Не ЗначениеЗаполнено(Объект.Период) Тогда
		Отказ = Истина;
		тСообщение = Новый СообщениеПользователю;
		тСообщение.Текст = НСтр("ru='Не указан период!'");
		тСообщение.Сообщить();
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	УстановитьНормыНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНормыНаСервере()
	
 	тПериод	= НачалоДня(КонецМесяца(Объект.Период));
	тГСМ	= "";
	тТС		= "";

	ЗапросН = Новый Запрос;
	ЗапросН.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	|	уатНормыРасходаГСМСрезПоследних.ГСМ,
	|	уатНормыРасходаГСМСрезПоследних.МодельТС,
	|	уатНормыРасходаГСМСрезПоследних.Организация,
	|	уатНормыРасходаГСМСрезПоследних.ЛинейнаяНорма,
	|	уатНормыРасходаГСМСрезПоследних.НормаНаЕздку,
	|	уатНормыРасходаГСМСрезПоследних.НормаНаЗапуск,
	|	уатНормыРасходаГСМСрезПоследних.НормаНаИзменениеСобственногоВеса,
	|	уатНормыРасходаГСМСрезПоследних.НормаНаОперацию,
	|	уатНормыРасходаГСМСрезПоследних.НормаНаОтопитель,
	|	уатНормыРасходаГСМСрезПоследних.НормаНаПростойСВклДвигателем,
	|	уатНормыРасходаГСМСрезПоследних.НормаНаПростойСВклДвигателемПроцентомОтБазовой,
	|	уатНормыРасходаГСМСрезПоследних.НормаНаТранспортнуюРаботу,
	|	уатНормыРасходаГСМСрезПоследних.НормаСпециальнаяНаКилометр,
	|	уатНормыРасходаГСМСрезПоследних.НормаСпециальнаяНаКилометр2,
	|	уатНормыРасходаГСМСрезПоследних.НормаСпециальнаяНаКилометр3,
	|	уатНормыРасходаГСМСрезПоследних.НормаСпециальнаяНаКилометр4,
	|	уатНормыРасходаГСМСрезПоследних.НормаСпециальнаяНаКилометр5,
	|	уатНормыРасходаГСМСрезПоследних.НормаСпециальнаяНаМоточас,
	|	уатНормыРасходаГСМСрезПоследних.СезоннаяНадбавка,
	|	уатНормыРасходаГСМСрезПоследних.УчитыватьПростоиДляРасчетаНормыМоточасов
	|ИЗ
	|	РегистрСведений.уатНормыРасходаГСМ.СрезПоследних(&Период, ) КАК уатНормыРасходаГСМСрезПоследних
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&Период, ) КАК уатМестонахождениеТССрезПоследних
	|		ПО уатНормыРасходаГСМСрезПоследних.МодельТС = уатМестонахождениеТССрезПоследних.ТС" + ?(НЕ ЗначениеЗаполнено(Объект.Подразделение), "", "
	|ГДЕ
	|	уатМестонахождениеТССрезПоследних.Подразделение = &Подразделение");
	ЗапросН.УстановитьПараметр("Период", КонецМесяца(Объект.Период));
	Если ЗначениеЗаполнено(Объект.Подразделение) Тогда
		ЗапросН.УстановитьПараметр("Подразделение", Объект.Подразделение);
	КонецЕсли;
	РезЗапроса = ЗапросН.Выполнить().Выбрать();
	Пока РезЗапроса.Следующий() Цикл
		
		тГСМ	= РезЗапроса.ГСМ;
		тТС		= РезЗапроса.МодельТС;
		
		тОбъект = РегистрыСведений.уатНормыРасходаГСМ.СоздатьНаборЗаписей();
		тОбъект.Отбор.Период.Установить(тПериод, Истина);
		тОбъект.Отбор.ГСМ.Установить(тГСМ, Истина);
		тОбъект.Отбор.МодельТС.Установить(тТС, Истина);
		тОбъект.Прочитать();
			
		Если тОбъект.Количество() = 0 Тогда
			НоваяСтрока = тОбъект.Добавить();
			НоваяСтрока.Период		= тПериод;
			НоваяСтрока.ГСМ			= тГСМ;
			НоваяСтрока.МодельТС	= тТС;
		Иначе
			НоваяСтрока = тОбъект[0];
		КонецЕсли;
		
		ЗаполнитьЗначенияСвойств(НоваяСтрока, РезЗапроса);
		НоваяСтрока.СезоннаяНадбавка	= Объект.СезонныйКоэффициент;
		
		тОбъект.ОбменДанными.Загрузка = Истина;
		Попытка
			тОбъект.Записать(Истина);
		Исключение
			тСообщение = Новый СообщениеПользователю;
			тСообщение.Текст = ОписаниеОшибки();
			тСообщение.Сообщить();
			Прервать;
		КонецПопытки;
	КонецЦикла;	
КонецПроцедуры

