#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс

Процедура УдалитьЛишниеЗаписиДляГруппыПозицийПодразделения(ПараметрыОбновления) Экспорт 
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1000
		|	МестоПозиции.Позиция КАК Позиция,
		|	МестоПозиции.Подразделение КАК Подразделение
		|ИЗ
		|	РегистрСведений.МестоПозицииШтатногоРасписанияВСтруктуреПредприятия КАК МестоПозиции
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ШтатноеРасписание КАК ШтатноеРасписание
		|		ПО (ШтатноеРасписание.Ссылка = МестоПозиции.Позиция)
		|			И (ШтатноеРасписание.ГруппаПозицийПодразделения)";
	РезультатЗапроса = Запрос.Выполнить();
	
	ПараметрыОбновления.ОбработкаЗавершена = Ложь;
	Если РезультатЗапроса.Пустой() Тогда
		ПараметрыОбновления.ОбработкаЗавершена = Истина;
		Возврат;
	КонецЕсли;
				   
	Выборка = РезультатЗапроса.Выбрать();
	Пока Выборка.Следующий() Цикл 
		Если Не НачатьОбновлениеНабораЗаписей(ПараметрыОбновления, Выборка.Позиция) Тогда
			Продолжить;
		КонецЕсли;
		НаборЗаписей = РегистрыСведений.МестоПозицииШтатногоРасписанияВСтруктуреПредприятия.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Позиция.Установить(Выборка.Позиция);
		ОбновлениеИнформационнойБазы.ЗаписатьНаборЗаписей(НаборЗаписей);
		ЗавершитьОбновлениеНабораЗаписей(ПараметрыОбновления);
	КонецЦикла;
															  
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НачатьОбновлениеНабораЗаписей(ПараметрыОбновления, Позиция)
	
	Возврат ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ПодготовитьОбновлениеДанных(
		ПараметрыОбновления, 
		"РегистрСведений.МестоПозицииШтатногоРасписанияВСтруктуреПредприятия", 
		"Позиция", 
		Позиция);
	
КонецФункции
	
Процедура ЗавершитьОбновлениеНабораЗаписей(ПараметрыОбновления)
	ОбновлениеИнформационнойБазыЗарплатаКадрыБазовый.ЗавершитьОбновлениеДанных(ПараметрыОбновления);
КонецПроцедуры

#КонецОбласти

#КонецЕсли