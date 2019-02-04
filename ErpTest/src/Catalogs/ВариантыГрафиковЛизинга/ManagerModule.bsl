#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Получает итоговые суммы текущего графика платежей по договору кредита, депозита, займа.
//
// Параметры;
//  Договор - СправочникСсылка.ДоговорыЛизинга, СправочникСсылка.ВариантыГрафиковЛизинга - договор кредита, депозита, займа; либо вариант графика договора
//
// Возвращаемое значение:
//  Структура - Ключ имя итога, Значение - итогова сумма графика.
//
Функция ИтогиГрафика(Договор) Экспорт
	
	ИтогиГрафика = Новый Структура("ДатаПоследнегоПлатежа, СуммаУслугПоЛизингу, СуммаОбеспечительногоПлатежа,
		|СуммаВыкупаПредметаЛизинга, НачисленияУслугПоЛизингу, НачисленияОбеспечительногоПлатежа, НачисленияВыкупПредметаЛизинга");
	
	ВариантГрафика = Неопределено;
	Если ТипЗнч(Договор) = Тип("СправочникСсылка.ДоговорыЛизинга") Тогда
		ВариантГрафика = ТекущийВариантГрафика(Договор);
	ИначеЕсли ТипЗнч(Договор) = Тип("СправочникСсылка.ВариантыГрафиковЛизинга") Тогда
		ВариантГрафика = Договор;
	КонецЕсли;
		
	Если Не ЗначениеЗаполнено(ВариантГрафика) Тогда
		Возврат ИтогиГрафика;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеГрафика.Период КАК ДатаПоследнегоПлатежа,
	|	ДанныеГрафика.УслугаПоЛизингуИтог КАК СуммаУслугПоЛизингу,
	|	ДанныеГрафика.ЗачетОбеспечительногоПлатежаИтог КАК СуммаОбеспечительногоПлатежа,
	|	ДанныеГрафика.ВыкупПредметаЛизингаИтог КАК СуммаВыкупаПредметаЛизинга
	|ИЗ
	|	РегистрСведений.ГрафикОплатЛизинга КАК ДанныеГрафика
	|ГДЕ
	|	ДанныеГрафика.ВариантГрафика = &ВариантГрафика
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеГрафика.Период УБЫВ
	|;
	|
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеГрафика.УслугаПоЛизингуИтог КАК НачисленияУслугПоЛизингу,
	|	ДанныеГрафика.ЗачетОбеспечительногоПлатежаИтог КАК НачисленияОбеспечительногоПлатежа,
	|	ДанныеГрафика.ВыкупПредметаЛизингаИтог КАК НачисленияВыкупПредметаЛизинга
	|ИЗ
	|	РегистрСведений.ГрафикНачисленийЛизинга КАК ДанныеГрафика
	|ГДЕ
	|	ДанныеГрафика.ВариантГрафика = &ВариантГрафика
	|УПОРЯДОЧИТЬ ПО
	|	ДанныеГрафика.Период УБЫВ
	|";
	
	Запрос.УстановитьПараметр("ВариантГрафика", ВариантГрафика);
	
	Результаты = Запрос.ВыполнитьПакет();
	
	Для каждого Результат Из Результаты Цикл
		Выборка = Результат.Выбрать();
		Если Выборка.Следующий() Тогда
			ЗаполнитьЗначенияСвойств(ИтогиГрафика, Выборка);
		КонецЕсли;
	КонецЦикла;
	
	Возврат ИтогиГрафика;
	
КонецФункции

// Обновляет сроки договора лизинга по графику платежей.
//
// Параметры:
//    Договор - СправочникОбъект.ДоговорыЛизинга - договор лизинга.
//    ИмяРеквизита - Строка - имя реквизита.
//
Процедура ПересчитатьСроки(Договор, ИмяРеквизита = "ДатаПоследнегоПлатежа") Экспорт
	
	ДатаДоговора = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Договор.Владелец, "Дата");
	
	Если ИмяРеквизита = "ДатаПоследнегоПлатежа" И ЗначениеЗаполнено(Договор.ДатаПоследнегоПлатежа) Тогда
		
		Договор.СрокМес = ОбщегоНазначенияУТ.РазностьДат(ДатаДоговора, Договор.ДатаПоследнегоПлатежа, Перечисления.Периодичность.Месяц);
		Договор.СрокДней = ОбщегоНазначенияУТ.РазностьДат(ДатаДоговора, Договор.ДатаПоследнегоПлатежа, Перечисления.Периодичность.День);
		
	ИначеЕсли ИмяРеквизита = "СрокМес" И ЗначениеЗаполнено(ДатаДоговора) Тогда
		
		Договор.ДатаПоследнегоПлатежа = ДобавитьМесяц(ДатаДоговора, Договор.СрокМес);
		Договор.СрокДней = ОбщегоНазначенияУТ.РазностьДат(ДатаДоговора, Договор.ДатаПоследнегоПлатежа, Перечисления.Периодичность.День);
		
	ИначеЕсли ИмяРеквизита = "СрокДней"  И ЗначениеЗаполнено(ДатаДоговора) Тогда
		
		Договор.ДатаПоследнегоПлатежа = ДатаДоговора + Договор.СрокДней * 60*60*24;
		Договор.СрокМес = ОбщегоНазначенияУТ.РазностьДат(ДатаДоговора, Договор.ДатаПоследнегоПлатежа, Перечисления.Периодичность.Месяц);
		
	ИначеЕсли ИмяРеквизита = "СрокМес" И ЗначениеЗаполнено(Договор.ДатаПоследнегоПлатежа) Тогда
		
		Договор.СрокДней = ОбщегоНазначенияУТ.РазностьДат(ДатаДоговора, Договор.ДатаПоследнегоПлатежа, Перечисления.Периодичность.День);
		
	ИначеЕсли ИмяРеквизита = "СрокДней" И ЗначениеЗаполнено(Договор.ДатаПоследнегоПлатежа) Тогда
		
		Договор.СрокМес = ОбщегоНазначенияУТ.РазностьДат(ДатаДоговора, Договор.ДатаПоследнегоПлатежа, Перечисления.Периодичность.Месяц);
		
	Иначе
		Договор.СрокМес = 0;
		Договор.СрокДней = 0;
	КонецЕсли;
	
КонецПроцедуры

// Для договора лизинга определяет текущий график платежей.
//
// Параметры;
//  Договор - СправочникСсылка.ДоговорыЛизинга - договор лизинга.
//
Функция ТекущийВариантГрафика(Договор) Экспорт
	
	Результат = Неопределено;
	
	Если Не ЗначениеЗаполнено(Договор) Тогда
		Возврат Результат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ ПЕРВЫЕ 1
	|	ДанныеСправочника.Ссылка
	|ИЗ
	|	Справочник.ВариантыГрафиковЛизинга КАК ДанныеСправочника
	|ГДЕ
	|	ДанныеСправочника.Владелец = &Договор
	|	И НЕ ДанныеСправочника.ПометкаУдаления
	|	И ДанныеСправочника.Используется
	|";
	
	Запрос.УстановитьПараметр("Договор", Договор);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Результат = Выборка.Ссылка;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт

	Ограничение.Текст =
	"ПрисоединитьДополнительныеТаблицы
	|ЭтотСписок КАК Т
	|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ИерархияПартнеров КАК Т2
	|	ПО Т2.Родитель = Т.Владелец.Партнер
	|;
	|РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Т2.Партнер)
	|	И ЗначениеРазрешено(Т.Владелец.Организация)";

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Отчеты

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
	Отчеты.ПланФактныйАнализФинансовыхИнструментов.ДобавитьКомандуОтчета(КомандыОтчетов, "ПланФактныйАнализЛизингКонтекст");
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли

