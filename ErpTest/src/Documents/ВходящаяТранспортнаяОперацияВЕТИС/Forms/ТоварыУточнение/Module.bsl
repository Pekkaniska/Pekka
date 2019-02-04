#Область ОписаниеПеременных

&НаКлиенте
Перем КэшированныеЗначения; //используется механизмом обработки изменения реквизитов ТЧ

#КонецОбласти

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	УстановитьУсловноеОформление();
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект.УстановитьПараметрыФункциональныхОпцийФормы(Параметры.ПараметрыФункциональныхОпций);
	
	Ссылка = Параметры.Документ;
	
	НомерСтроки = 0;
	Для каждого Строка Из Параметры.ТоварыУточнение Цикл
		НоваяСтрока = ТоварыУточнение.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		НомерСтроки = НомерСтроки + 1;
		НоваяСтрока.НомерСтроки = НомерСтроки;
		НоваяСтрока.ЗаписьСкладскогоЖурнала = Параметры.ЗаписьСкладскогоЖурнала;
	КонецЦикла;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "ВетеринарноСопроводительныйДокумент, Продукция, КоличествоВЕТИС, ЕдиницаИзмеренияВЕТИС, ЗаписьСкладскогоЖурнала, РедактированиеФормыНедоступно");
	
	Если РедактированиеФормыНедоступно Тогда
		УстановитьНедоступностьЭлементовВЕТИС();
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ЗаписьСкладскогоЖурнала) Тогда
		ПредставлениеЗаписьСкладскогоЖурнала = Новый ФорматированнаяСтрока(
		Строка(ЗаписьСкладскогоЖурнала),,,, ПолучитьНавигационнуюСсылку(ЗаписьСкладскогоЖурнала));
	Иначе
		ПредставлениеЗаписьСкладскогоЖурнала = Новый ФорматированнаяСтрока(
		НСтр("ru = '<будет создана автоматически>'"),, ЦветТекстаПоля("ТекстЗапрещеннойЯчейкиЦвет"));
	КонецЕсли;
	
	ЗаполнитьПроизводителей();
	ЗаполнитьДоступныеИдентификаторыПартий();
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСлужебныеРеквизитыВКоллекции(ЭтотОбъект, ТоварыУточнение);
	
	Если Параметры.Свойство("ТорговыйОбъект") Тогда
		ТорговыйОбъект = Параметры.ТорговыйОбъект;
	КонецЕсли;
	
	Если Параметры.Свойство("ПараметрыУказанияСерий") Тогда
		ПараметрыУказанияСерий = Параметры.ПараметрыУказанияСерий;
	КонецЕсли;
	
	УстановитьВидимостьЭлементовСерий();
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		ЗаполнитьСтатусыУказанияСерийСервер();
	КонецЕсли;
	
	Если Параметры.Свойство("МассивНоменклатурыДляВыбора") Тогда
		Для каждого Строка Из Параметры.МассивНоменклатурыДляВыбора Цикл
			НоваяСтрока = НоменклатураДляВыбора.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Строка);
		КонецЦикла;
	Иначе
		ИнтеграцияВЕТИС.ЗаполнитьСопоставленныеТовары(ТоварыУточнение, НоменклатураДляВыбора, Продукция);
	КонецЕсли;
	
	ПредставлениеКоличества = Новый ФорматированнаяСтрока(СтрШаблон("%1 (%2)", КоличествоВЕТИС, ЕдиницаИзмеренияВЕТИС));
	
	ИнтеграцияВЕТИСПереопределяемый.УстановитьПараметрыВыбораНоменклатуры(ЭтотОбъект, "ТоварыУточнениеНоменклатура");
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,
																									"ТоварыУточнениеХарактеристика",
																									"Элементы.ТоварыУточнение.ТекущиеДанные.Номенклатура");
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьСвязиПараметровВыбораСНоменклатурой(ЭтотОбъект,
																									"ТоварыУточнениеСерия",
																									"Элементы.ТоварыУточнение.ТекущиеДанные.Номенклатура");
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьДанные", ЭтотОбъект, "ТоварыУточнениеНоменклатура");
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(ОписаниеОповещения, ВыбранноеЗначение,
		ИсточникВыбора);
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		СобытияФормВЕТИСКлиентПереопределяемый.ОбработкаВыбораСерии(ЭтотОбъект,
																	ПараметрыУказанияСерий,
																	ВыбранноеЗначение,
																	ИсточникВыбора);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаЗаписиНового(НовыйОбъект, Источник, СтандартнаяОбработка)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбновитьДанные", ЭтотОбъект, "ТоварыУточнениеНоменклатура");
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОбработкаВыбораНоменклатуры(ОписаниеОповещения, НовыйОбъект, Источник);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	МассивНепроверяемыхРеквизитов = Новый Массив;
	
	ИнтеграцияВЕТИСПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийСпискаФормыТоварыУточнениеСерии

&НаКлиенте
Процедура ТоварыПередУдалением(Элемент, Отказ)
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,
			КэшированныеЗначения, ПараметрыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		НеобходимоОбновитьСтатусыСерий = ГосударственныеИнформационныеСистемыКлиентПереопределяемый.НеобходимоОбновитьСтатусыСерий(
										Элемент, КэшированныеЗначения, ПараметрыУказанияСерий, Истина);
	
	Иначе
		НеобходимоОбновитьСтатусыСерий = Ложь;
	КонецЕсли;
	
	Если НеобходимоОбновитьСтатусыСерий Тогда
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(Неопределено, КэшированныеЗначения);
		
		ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,
			КэшированныеЗначения, ПараметрыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Элементы.ТоварыУточнение.ТекущиеДанные.ЗаписьСкладскогоЖурнала = ЗаписьСкладскогоЖурнала;
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,
			КэшированныеЗначения, ПараметрыУказанияСерий, Копирование);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	ТекущиеДанные = Элементы.ТоварыУточнение.ТекущиеДанные;
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		НеобходимоОбновитьСтатусыСерий = ГосударственныеИнформационныеСистемыКлиентПереопределяемый.НеобходимоОбновитьСтатусыСерий(
										Элемент, КэшированныеЗначения, ПараметрыУказанияСерий);
	
	Иначе
		НеобходимоОбновитьСтатусыСерий = Ложь;
	КонецЕсли;
	
	Если НеобходимоОбновитьСтатусыСерий Тогда
		ТекущаяСтрокаИдентификатор = ТекущиеДанные.ПолучитьИдентификатор();
		
		ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
		
		ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ОбновитьКешированныеЗначенияДляУчетаСерий(Элемент,
			КэшированныеЗначения, ПараметрыУказанияСерий);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриАктивизацииЯчейки(Элемент)
	
	ТекущиеДанные = Элементы.ТоварыУточнение.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ТоварыУточнениеНоменклатура Тогда
		
		Отбор = Новый Структура("Продукция", Продукция);
		МассивЗначенийДляВыбора = ИнтеграцияВЕТИСКлиентСервер.МассивЗначенийДляВыбораИзСписка("Номенклатура", НоменклатураДляВыбора, Отбор);
		Элементы.ТоварыУточнениеНоменклатура.СписокВыбора.ЗагрузитьЗначения(МассивЗначенийДляВыбора);
		
	КонецЕсли;
	
	Если Элемент.ТекущийЭлемент = Элементы.ТоварыУточнениеХарактеристика Тогда
		
		Отбор = Новый Структура("Продукция, Номенклатура", Продукция, ТекущиеДанные.Номенклатура);
		МассивЗначенийДляВыбора = ИнтеграцияВЕТИСКлиентСервер.МассивЗначенийДляВыбораИзСписка("Характеристика", НоменклатураДляВыбора, Отбор);
		Элементы.ТоварыУточнениеХарактеристика.СписокВыбора.ЗагрузитьЗначения(МассивЗначенийДляВыбора);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	
	НоменклатураПриИзменении();
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ТоварыУточнение.ТекущиеДанные;
	
	ПараметрыНоменклатуры = ИнтеграцияВЕТИСВызовСервера.ПараметрыСозданияНоменклатуры(Продукция, ЕдиницаИзмеренияВЕТИС);
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОткрытьФормуВыбораНоменклатуры(ЭтотОбъект, ПараметрыНоменклатуры);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыНоменклатураСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.ТоварыУточнение.ТекущиеДанные;
	
	ПараметрыНоменклатуры = ИнтеграцияВЕТИСВызовСервера.ПараметрыСозданияНоменклатуры(Продукция, ЕдиницаИзмеренияВЕТИС);
	
	СобытияФормВЕТИСКлиентПереопределяемый.ОткрытьФормуСозданияНоменклатуры(ЭтотОбъект, ПараметрыНоменклатуры, ЕдиницаИзмеренияВЕТИС);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаПриИзменении(Элемент)
	ТекущиеДанные = Элементы.ТоварыУточнение.ТекущиеДанные;
	Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) 
		И ((ТекущиеДанные.ХарактеристикиИспользуются И ЗначениеЗаполнено(ТекущиеДанные.Характеристика))
			ИЛИ НЕ ТекущиеДанные.ХарактеристикиИспользуются) Тогда
		ТекущиеДанные.Сопоставлено = Истина;
	Иначе
		ТекущиеДанные.Сопоставлено = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ТоварыУточнение.ТекущиеДанные;
	
	СобытияФормВЕТИСКлиентПереопределяемый.НачалоВыбораХарактеристики(ЭтотОбъект, ТекущаяСтрока, Элемент, ДанныеВыбора, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыХарактеристикаСоздание(Элемент, СтандартнаяОбработка)
	
	ГосударственныеИнформационныеСистемыКлиентПереопределяемый.ХарактеристикаСоздание(Элемент, СтандартнаяОбработка);
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияПриИзменении(Элемент)
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииСерии(ЭтотОбъект,
																ПараметрыУказанияСерий,
																Элементы.ТоварыУточнение.ТекущиеДанные);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСерияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ПараметрыУказанияСерий <> Неопределено
		И ИнтеграцияВЕТИСКлиент.ДляУказанияСерийНуженСерверныйВызов(ЭтаФорма, ПараметрыУказанияСерий, Элемент.ТекстРедактирования, СтандартнаяОбработка) Тогда
		ТекстИсключения = НСтр("ru = 'Ошибка при попытке указать серии - в этом документе для указания серий не нужен серверный вызов.'");
		
		ВызватьИсключение ТекстИсключения;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	
	ОчиститьСообщения();
	ТекущиеДанные = Элементы.ТоварыУточнение.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС = ЕдиницаИзмеренияВЕТИС;
	
	Если РедактированиеФормыНедоступно Тогда
		
		ВведенноеЗначение = ТекущиеДанные.Количество;
		
		ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС = Истина;
		
		СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииКоличестваВЕТИС(ЭтотОбъект, ТекущиеДанные,
			КэшированныеЗначения, ПараметрыЗаполнения);
			
		Если НЕ ВведенноеЗначение = ТекущиеДанные.Количество Тогда
			ТекстСообщения = НСтр("ru='Документ был передан в информационную систему ВетИС.
				|Количество номенклатуры должно соответствовать количеству ВетИС с учетом коэффициентов пересчета.'");
			
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		КонецЕсли;
		
	Иначе
		
		ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницВЕТИС = Истина;
		
		СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииКоличества(ЭтотОбъект, ТекущиеДанные,
		КэшированныеЗначения, ПараметрыЗаполнения);
		
		КоличествоВЕТИС = ТоварыУточнение.Итог("КоличествоВЕТИС");
		ПредставлениеКоличества = Новый ФорматированнаяСтрока(СтрШаблон("%1 (%2)", КоличествоВЕТИС, ЕдиницаИзмеренияВЕТИС));
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоВЕТИСПриИзменении(Элемент)
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.ТоварыУточнение.ТекущиеДанные;
	
	ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС              = ЕдиницаИзмеренияВЕТИС;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС = Истина;
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииКоличестваВЕТИС(ЭтотОбъект, ТекущиеДанные,
		КэшированныеЗначения, ПараметрыЗаполнения);
		
	КоличествоВЕТИС = ТоварыУточнение.Итог("КоличествоВЕТИС");
	ПредставлениеКоличества = Новый ФорматированнаяСтрока(СтрШаблон("%1 (%2)", КоличествоВЕТИС, ЕдиницаИзмеренияВЕТИС));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Готово(Команда)
	Отказ = Ложь;
	ОбработкаПроверкиЗаполненияНаСервере(Отказ, Новый Массив);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	Если Модифицированность Тогда
		Закрыть(ТоварыУточнение);
	Иначе
		Закрыть();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтроку(Команда)
	
	КоличествоРазбить = ?(Элементы.ТоварыУточнение.ТекущиеДанные = Неопределено, КоличествоВЕТИС, Элементы.ТоварыУточнение.ТекущиеДанные.КоличествоВЕТИС);
	Оповещение = Новый ОписаниеОповещения("РазбитьСтрокуЗавершение", ЭтотОбъект);
	
	ПараметрыРазбиенияСтроки = Новый Структура;
	ПараметрыРазбиенияСтроки.Вставить("ИмяПоляКоличество", "КоличествоВЕТИС");
	ПараметрыРазбиенияСтроки.Вставить("Заголовок", НСтр("ru = 'Введите количество товара в новой строке'"));
	ПараметрыРазбиенияСтроки.Вставить("РазрешитьНулевоеКоличество", Ложь);
	ПараметрыРазбиенияСтроки.Вставить("Количество", КоличествоРазбить);
	
	ИнтеграцияВЕТИСКлиентПереопределяемый.РазбитьСтрокуТабличнойЧасти(ТоварыУточнение, Элементы.ТоварыУточнение, Оповещение, ПараметрыРазбиенияСтроки);
	
КонецПроцедуры

&НаКлиенте
Процедура СгенерироватьСерии(Команда)
	
	ОчиститьСообщения();
	
	Результат = СгенерироватьСерииНаСервере();
	
	ИнтеграцияВЕТИСКлиент.ОповеститьОбОкончанииЗаполненияСерийВДокументе(Результат.ЗаполнениеЗавершено,
		Результат.СписокОшибок);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОбновитьДанные(Результат, ДополнительныеПараметры = Неопределено) Экспорт
	
	Если ДополнительныеПараметры = "ТоварыУточнениеНоменклатура" Тогда
		Элементы.ТоварыУточнение.ТекущиеДанные.Номенклатура = Результат;
		НоменклатураПриИзменении();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура РазбитьСтрокуЗавершение(НоваяСтрока, ДополнительныеПараметры = Неопределено) Экспорт 
	
	ОчиститьСообщения();
	ТекущаяСтрока = Элементы.ТоварыУточнение.ТекущиеДанные;
	ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС              = ЕдиницаИзмеренияВЕТИС;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС = Истина;
	
	Если НоваяСтрока <> Неопределено Тогда
		
		СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииКоличестваВЕТИС(ЭтотОбъект, ТекущаяСтрока,
			КэшированныеЗначения, ПараметрыЗаполнения);
		СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииКоличестваВЕТИС(ЭтотОбъект, НоваяСтрока,
			КэшированныеЗначения, ПараметрыЗаполнения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьУсловноеОформление()
	
	УсловноеОформление.Элементы.Очистить();
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыУточнениеНоменклатура.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТоварыУточнение.Номенклатура");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("ТоварыУточнение.СопоставлениеНоменклатура"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблемаЕГАИС);
	
	Элемент = УсловноеОформление.Элементы.Добавить();
	
	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыУточнениеХарактеристика.Имя);
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТоварыУточнение.Характеристика");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.НеЗаполнено;
	
	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("ТоварыУточнение.ХарактеристикиИспользуются");
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ОтборЭлемента.ПравоеЗначение = Истина;
	
	Элемент.Оформление.УстановитьЗначениеПараметра("Текст", Новый ПолеКомпоновкиДанных("ТоварыУточнение.СопоставлениеХарактеристика"));
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветТекстаПроблемаЕГАИС);
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеХарактеристикНоменклатуры(ЭтотОбъект,
																							"ТоварыУточнениеХарактеристика",
																							"ТоварыУточнение.ХарактеристикиИспользуются");
	
	Если Не ГосударственныеИнформационныеСистемыПереопределяемый.ХарактеристикиИспользуются() Тогда
	
		Элемент = УсловноеОформление.Элементы.Добавить();
		
		ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
		ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(Элементы.ТоварыУточнениеХарактеристика.Имя);
		
		Элемент.Оформление.УстановитьЗначениеПараметра("Видимость", Ложь);
		
	КонецЕсли;
	
	ГосударственныеИнформационныеСистемыПереопределяемый.УстановитьУсловноеОформлениеСерийНоменклатуры(ЭтотОбъект,
																					"ТоварыУточнениеСерия",
																					"ТоварыУточнение.СтатусУказанияСерий",
																					"ТоварыУточнение.ТипНоменклатуры");
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНедоступностьЭлементовВЕТИС()
	
	Элементы.ТоварыУточнениеКоличествоВЕТИС.ТолькоПросмотр = Истина;
	Элементы.ТоварыУточнениеИдентификаторПартии.ТолькоПросмотр = Истина;
	Элементы.ТоварыУточнение.ИзменятьСоставСтрок = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура НоменклатураПриИзменении()
	
	ОчиститьСообщения();
	
	ТекущиеДанные = Элементы.ТоварыУточнение.ТекущиеДанные;
	
	Если Не ЗначениеЗаполнено(ТекущиеДанные.Номенклатура) Тогда
		ТекущиеДанные.Характеристика = Неопределено;
	КонецЕсли;
	
	ПараметрыЗаполнения = ИнтеграцияВЕТИСКлиентСервер.ПараметрыЗаполненияТабличнойЧасти();
	ПараметрыЗаполнения.ЕдиницаИзмеренияВЕТИС              = ЕдиницаИзмеренияВЕТИС;
	ПараметрыЗаполнения.ПересчитатьКоличествоЕдиницПоВЕТИС = Истина;
	ПараметрыЗаполнения.ПроверитьСериюРассчитатьСтатус     = ПараметрыУказанияСерий <> Неопределено;
	
	СобытияФормВЕТИСКлиентПереопределяемый.ПриИзмененииНоменклатуры(ЭтотОбъект, ТекущиеДанные, КэшированныеЗначения,
		ПараметрыЗаполнения, ПараметрыУказанияСерий);
	
	Если ЗначениеЗаполнено(ТекущиеДанные.Номенклатура)
		И ((ТекущиеДанные.ХарактеристикиИспользуются
				И ЗначениеЗаполнено(ТекущиеДанные.Характеристика))
			ИЛИ НЕ ТекущиеДанные.ХарактеристикиИспользуются) Тогда
		
		ТекущиеДанные.Сопоставлено = Истина;
		
	Иначе
		ТекущиеДанные.Сопоставлено = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПроизводителей()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	Производители.Производитель   КАК Производитель,
	|	Производители.РольПредприятия КАК РольПредприятия
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС.Производители КАК Производители
	|ГДЕ
	|	Производители.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ВетеринарноСопроводительныйДокумент);
	
	ТаблицаПроизводители = Запрос.Выполнить().Выгрузить();
	ЗначениеВДанныеФормы(ТаблицаПроизводители, Производители);
	
	СтрокаПроизводители = ИнтеграцияВЕТИСКлиентСервер.СформироватьНадписьПоДаннымТабличнойЧасти(
		Производители,
		ИнтеграцияВЕТИСКлиентСервер.ПараметрыПредставленияТабличнойЧастиПроизводителей());
	
	ПредставлениеПроизводители = Новый ФорматированнаяСтрока(СтрокаПроизводители,,,, "ОткрытьПроизводителей");
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьДоступныеИдентификаторыПартий()
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	ПроизводственныеПартии.ИдентификаторПартии КАК ИдентификаторПартии
	|ИЗ
	|	Справочник.ВетеринарноСопроводительныйДокументВЕТИС.ПроизводственныеПартии КАК ПроизводственныеПартии
	|ГДЕ
	|	ПроизводственныеПартии.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ВетеринарноСопроводительныйДокумент);
	
	Элементы.ТоварыУточнениеИдентификаторПартии.СписокВыбора.ЗагрузитьЗначения(Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("ИдентификаторПартии"));
	
	Если Элементы.ТоварыУточнениеИдентификаторПартии.СписокВыбора.Количество() Тогда
		Элементы.ТоварыУточнениеИдентификаторПартии.АвтоОтметкаНезаполненного = Истина;
	КонецЕсли;
	
КонецПроцедуры

#Область Серии

&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийСервер()
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСтатусыУказанияСерий(ЭтотОбъект,
		ПараметрыУказанияСерий);
	
КонецПроцедуры

&НаСервере
Процедура УстановитьВидимостьЭлементовСерий()
	
	Если ПараметрыУказанияСерий <> Неопределено Тогда
		ИспользоватьСерииНоменклатуры = ПараметрыУказанияСерий.ИспользоватьСерииНоменклатуры;
	Иначе
		ИспользоватьСерииНоменклатуры = Ложь;
	КонецЕсли;
	
	Элементы.ТоварыУточнениеСгенерироватьСерии.Видимость = ИспользоватьСерииНоменклатуры;
	Элементы.ТоварыУточнениеСерия.Видимость              = ИспользоватьСерииНоменклатуры;
	
КонецПроцедуры

&НаСервере
Функция СгенерироватьСерииНаСервере()
	
	Результат = ИнтеграцияВЕТИС.СгенерироватьСерии(ЭтотОбъект, ТоварыУточнение, Элементы.ТоварыУточнение.ВыделенныеСтроки, ПараметрыУказанияСерий);
	
	Возврат Результат;
	
КонецФункции
	
&НаСервере
Процедура ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(ТекущаяСтрокаИдентификатор,
																		КэшированныеЗначения)
	
	ГосударственныеИнформационныеСистемыПереопределяемый.ЗаполнитьСтатусыУказанияСерийПриОкончанииРедактированияСтрокиТЧ(
		ЭтотОбъект, ПараметрыУказанияСерий, ТекущаяСтрокаИдентификатор, КэшированныеЗначения);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаНавигационнойСсылки(НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	
	Если НавигационнаяСсылкаФорматированнойСтроки = "ОткрытьПроизводителей" Тогда
		
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Производители", Производители);
		ПараметрыФормы.Вставить("ТолькоПросмотр", Истина);
		
		ОткрытьФорму(
			"ОбщаяФорма.ПроизводителиВЕТИС",
			ПараметрыФормы, ЭтотОбъект,,,,,
			РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Функция ЦветТекстаПоля(ИмяЦвета = "ЦветОсобогоТекста")
	
	#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
		Возврат ЦветаСтиля[ИмяЦвета];
	#Иначе
		Возврат ОбщегоНазначенияКлиент.ЦветСтиля(ИмяЦвета);
	#КонецЕсли
	
КонецФункции

#КонецОбласти

#КонецОбласти
