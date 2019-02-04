#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	Возврат "Отчет.РегламентированноеУведомлениеТС1.Форма.Форма2015_1";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2015_1";
	Стр.ОписаниеФормы = "ТС-1/приказ ФНС России от 22.06.2015 № ММВ-7-14/249@";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат ПечатьСразу_Форма2015_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат СформироватьМакет_Форма2015_1(Объект);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2015_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2015_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция СформироватьМакет_Форма2015_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2015_1");
	ОбластьТитульный = МакетУведомления.ПолучитьОбласть("Титульный");
	ПараметрыМакета = ОбластьТитульный.Параметры;
	СтруктураПараметров = Объект.ДанныеУведомления.Получить();
	Титульный = СтруктураПараметров.Титульный[0];
	
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_ИНН, "ИНН_", ПараметрыМакета, 12, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_КПП, "КПП_", ПараметрыМакета, 9, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.КОД_НО, "КОД_НО_", ПараметрыМакета, 4, "-");
	ПараметрыМакета.КодПричины = ?(ЗначениеЗаполнено(Титульный.КодПричины), Титульный.КодПричины, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ, "ОрганизацияНазвание_", ПараметрыМакета, 160, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ОГРН, "ОГРН_", ПараметрыМакета, 13, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ОГРНИП, "ОГРНИП_", ПараметрыМакета, 15, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Титульный.ПРИЛОЖЕНО_ЛИСТОВ, "ПриложеноЛистов_", ПараметрыМакета, 3, Истина, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Титульный.КОЛИЧЕСТВО_СТРАНИЦ, "КоличествоСтраниц_", ПараметрыМакета, 3, Истина, "-");
	
	ПараметрыМакета.ПризнакПодписанта = Титульный.ПРИЗНАК_НП_ПОДВАЛ;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантФамилия, "ОргПодписантФамилия_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантИмя, "ОргПодписантИмя_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Объект.ПодписантОтчество, "ОргПодписантОтчество_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ИНН_ПОДПИСАНТА, "ИНН_ПОДПИСАНТ_", ПараметрыМакета, 12, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20, "-");
	ПараметрыМакета.Email = Титульный.EMAIL_ПОДПИСАНТА;
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ТЕЛЕФОН, "Телефон_", ПараметрыМакета, 20, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ, "ДокументПредставителя_", ПараметрыМакета, 40, "-");
	Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(Титульный.ДАТА_ПОДПИСИ, "ДатаПодписи_", ПараметрыМакета, "-");
	
	ПечатнаяФорма.Вывести(ОбластьТитульный);
	ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	
	Страница = 1;
	Для Каждого ДопЛист Из СтруктураПараметров.Сведения Цикл 
		ОбластьДопЛист = МакетУведомления.ПолучитьОбласть("Сведения");
		ПараметрыМакета = ОбластьДопЛист.Параметры;
		Страница = Страница + 1;
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_ИНН, "ИНН_", ПараметрыМакета, 12, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Титульный.П_КПП, "КПП_", ПараметрыМакета, 9, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета("000", "СТР_", ПараметрыМакета, 3);
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(Страница, "СТР_", ПараметрыМакета, 3);
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.ИНДЕКС, "Индекс_", ПараметрыМакета, 6, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.КОД_РЕГИОНА, "КодСубъекта_", ПараметрыМакета, 2, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.РАЙОН, "Район_", ПараметрыМакета, 34, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.ГОРОД, "Город_", ПараметрыМакета, 34, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.НАСЕЛЕННЫЙ_ПУНКТ, "НаселенныйПункт_", ПараметрыМакета, 34, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.УЛИЦА, "Улица_", ПараметрыМакета, 34, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.ДОМ, "Дом_", ПараметрыМакета, 8, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.КОРПУС, "Корпус_", ПараметрыМакета, 8, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.КВАРТИРА, "Квартира_", ПараметрыМакета, 8, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Формат(ДопЛист.КодВидаПД, "ЧЦ=2; ЧН=--; ЧВН="), "КодВД_", ПараметрыМакета, 2, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(Формат(ДопЛист.КодВидаТоргОбъекта, "ЧЦ=2; ЧН=--; ЧВН="), "КодТорг_", ПараметрыМакета, 2, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.ОКТМО, "ОКТМО_", ПараметрыМакета, 11, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.НаимТоргОб, "НаимТорг_", ПараметрыМакета, 40, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.ДатаВПараметрыМакета(ДопЛист.ДАТА_ПРАВА, "ДатаИсп_", ПараметрыМакета, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.НомерРазр, "НомерРазр_", ПараметрыМакета, 15, "-");
		ПараметрыМакета.КодОснования  = ДопЛист.ОснИсп;
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.НомЗдание, "КадастровыйНомерЗдания_", ПараметрыМакета, 40, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.НомПомещ, "КадастровыйНомерПомещения_", ПараметрыМакета, 40, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.НомУч, "КадастровыйНомерУчастка_", ПараметрыМакета, 40, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.СтрокаВПараметрыМакета(ДопЛист.КодЛьготы, "КодЛьготы_", ПараметрыМакета, 12, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(ДопЛист.СтавкаСбораРуб, "СтавкаТорг_", ПараметрыМакета, 8, , "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(ДопЛист.ИсчСуммаСбора, "ИсчСбор_", ПараметрыМакета, 8, , "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(ДопЛист.СуммаЛьготы, "Льгота_", ПараметрыМакета, 8, , "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоВПараметрыМакета(ДопЛист.СуммаСбораИтого, "СуммаСбора_", ПараметрыМакета, 8, ,"-");
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоСРазделителемВПараметрыМакета(ДопЛист.ПлощТоргЗала, 7, 2, "ПлощТоргЗала_", ПараметрыМакета, "-");
		Документы.УведомлениеОСпецрежимахНалогообложения.ЧислоСРазделителемВПараметрыМакета(ДопЛист.СтавкаСбораКвм, 8, 2, "СтавкаПлощ_", ПараметрыМакета, "-");
		
		ПечатнаяФорма.Вывести(ОбластьДопЛист);
		ПечатнаяФорма.ВывестиГоризонтальныйРазделительСтраниц();
	КонецЦикла;
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2015_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2015_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2015_1(СведенияОтправки)
	Префикс = "UT_UVTORGSB";
	Возврат Документы.УведомлениеОСпецрежимахНалогообложения.ИдентификаторФайлаЭлектронногоПредставления(Префикс, СведенияОтправки);
КонецФункции

Процедура Проверить_Форма2015_1(Данные, УникальныйИдентификатор)
	Титульный = Данные.Титульный[0];
	
	Ошибок = 0;
	Если Не ЗначениеЗаполнено(Титульный.КодПричины) Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Не заполнен код уведомления на титульном листе", УникальныйИдентификатор);
		Ошибок = Ошибок + 1;
	КонецЕсли;
	
	Сообщение = "";
	Страница = 0;
	Для Каждого Лист Из Данные.Сведения Цикл
		Страница = Страница + 1;
		
		Если (Не ЗначениеЗаполнено(Лист.ДАТА_ПРАВА))
			Или (Не ЗначениеЗаполнено(Лист.КодВидаПД))
			Или (Не ЗначениеЗаполнено(Лист.ОКТМО))
			Или (Не ЗначениеЗаполнено(Лист.КодВидаТоргОбъекта))
			Или (Не ЗначениеЗаполнено(Лист.ОснИсп))
			Или (Не ЗначениеЗаполнено(Лист.НомерРазр)) Тогда 
			
			Ошибок = Ошибок + 1;
			Сообщение = ?(ЗначениеЗаполнено(Сообщение), Сообщение + Символы.ПС, Сообщение);
			Сообщение = Сообщение + "Не заполнены обязательные реквизиты на странице " + Страница + ": показатели в строках 1.1, 1.2, 2.1, 2.2, 2.4(код региона), 2.5, 2.6 должны быть заполнены";
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Лист.СтавкаСбораКвм) И (Не ЗначениеЗаполнено(Лист.ПлощТоргЗала)) Тогда 
			Ошибок = Ошибок + 1;
			Сообщение = ?(ЗначениеЗаполнено(Сообщение), Сообщение + Символы.ПС, Сообщение);
			Сообщение = Сообщение + "На странице " + Страница + " не заполнен показатель в строке 2.10";
		ИначеЕсли (Лист.КодВидаПД = 3 Или Лист.КодВидаПД = 5) И ЗначениеЗаполнено(Лист.СтавкаСбораРуб) И (Не ЗначениеЗаполнено(Лист.ПлощТоргЗала)) Тогда
			Ошибок = Ошибок + 1;
			Сообщение = ?(ЗначениеЗаполнено(Сообщение), Сообщение + Символы.ПС, Сообщение);
			Сообщение = Сообщение + "На странице " + Страница + " не заполнен показатель в строке 2.10";
		КонецЕсли;
		
		Если (Не ЗначениеЗаполнено(Лист.СтавкаСбораКвм)) И (Не ЗначениеЗаполнено(Лист.СтавкаСбораРуб)) Тогда 
			Ошибок = Ошибок + 1;
			Сообщение = ?(ЗначениеЗаполнено(Сообщение), Сообщение + Символы.ПС, Сообщение);
			Сообщение = Сообщение + "На странице " + Страница + " должна быть заполнена строка 3.1 либо 3.2";
		КонецЕсли;
		
		Если Ошибок >= 3 Тогда
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении(Сообщение, УникальныйИдентификатор);
			ВызватьИсключение "";
		КонецЕсли;
	КонецЦикла;
	
	Если Ошибок > 0 Тогда
		РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении(Сообщение, УникальныйИдентификатор);
		ВызватьИсключение "";
	КонецЕсли;
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2015_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	
	ОсновныеСведения.Вставить("ЭтоПБОЮЛ", Не РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация));
	
	Если ОсновныеСведения.ЭтоПБОЮЛ Тогда
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПФЛ(Объект, ОсновныеСведения);
	Иначе 
		Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьДанныеНПЮЛ(Объект, ОсновныеСведения);
	КонецЕсли;
	
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьОбщиеДанные(Объект, ОсновныеСведения);
	Данные = Объект.ДанныеУведомления.Получить();
	Проверить_Форма2015_1(Данные, УникальныйИдентификатор);
	Титульный = Данные.Титульный[0];
	
	ОсновныеСведения.Вставить("ПрТоргСбор", Титульный.КодПричины);
	ОсновныеСведения.Вставить("ИННПодп", Титульный.ИНН_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("EmailПодп", Титульный.EMAIL_ПОДПИСАНТА);
	ОсновныеСведения.Вставить("Тлф", Титульный.ТЕЛЕФОН);
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2015_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	ОсновныеСведения.Вставить("НаимОргПредст", Титульный.ОРГ_ПРЕДСТАВИТЕЛЬ);
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ЭлектронноеПредставление_Форма2015_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2015_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2015_1");
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(ОсновныеСведения, СтруктураВыгрузки);
	ЗаполнитьДанными_Форма2015_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = Документы.УведомлениеОСпецрежимахНалогообложения.ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "windows-1251";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2015_1(Объект, Параметры, ДеревоВыгрузки)
	Данные = Объект.ДанныеУведомления.Получить();
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "Документ");
	Узел_УчетТоргСбор = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "УчетТоргСбор");
	Узел_ОбТоргСбор = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_УчетТоргСбор, "ОбТоргСбор");
	
	Нумератор = 1;
	КП = Данные.Титульный[0].КодПричины;
	Для Каждого СтрСвед Из Данные.Сведения Цикл
		НовыйУзел_ОбТоргСбор = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел_ОбТоргСбор);
		Узел_СведВидПД = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(НовыйУзел_ОбТоргСбор, "СведВидПД");
		Узел_СведОбТорг = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(НовыйУзел_ОбТоргСбор, "СведОбТорг");
		Узел_АдрОбТорг = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СведОбТорг, "АдрОбТорг");
		Узел_РасчСумСбор = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(НовыйУзел_ОбТоргСбор, "РасчСумСбор");
		
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведВидПД, "ДатаВозникИсп", Формат(СтрСвед.ДАТА_ПРАВА, "ДФ=dd.MM.yyyy"));
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведВидПД, "КодВидТорг", Формат(СтрСвед.КодВидаПД, "ЧЦ=2; ЧВН="));
		
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "ОКТМО", СтрСвед.ОКТМО);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "КодВидОб", Формат(СтрСвед.КодВидаТоргОбъекта, "ЧЦ=2; ЧВН="));
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "НаимТоргОб", СтрСвед.НаимТоргОб);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "ОснПользОб", СтрСвед.ОснИсп);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "НомерРазр", СтрСвед.НомерРазр);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "КадастрНомЗд", СтрСвед.НомЗдание);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "КадастНомПом", СтрСвед.НомПомещ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "КадастНомЗУ", СтрСвед.НомУч);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "ПлощОбТорг", СтрСвед.ПлощТоргЗала);
		Если КП = "1" Тогда
			Нумератор = Нумератор + 1;
			Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведОбТорг, "НомОбъект", Формат(Нумератор, "ЧЦ=3; ЧВН="));
			РегламентированнаяОтчетность.УдалитьУзел(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СведОбТорг, "ИдОбъект"));
		ИначеЕсли КП = "2" Или КП = "3" Тогда
			Если СтрСвед.ИспользоватьФайлАкт Тогда
				Узел_ИдОбъект = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СведОбТорг, "ИдОбъект");
				Узел_СведАкт = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ИдОбъект, "СведАкт");
				Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведАкт, "НомАкт", СтрСвед.НомерАкт);
				Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведАкт, "ДатаАкт", Формат(СтрСвед.ДатаАкт, "ДФ=dd.MM.yyyy"));
				РегламентированнаяОтчетность.УдалитьУзел(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ИдОбъект, "СведУвед"));
			Иначе
				Узел_ИдОбъект = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СведОбТорг, "ИдОбъект");
				Узел_СведУвед = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ИдОбъект, "СведУвед");
				Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведУвед, "НомОбъектУв", Формат(СтрСвед.НомОбъектУв, "ЧЦ=3; ЧВН="));
				Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_СведУвед, "ИдФайлУв", СтрСвед.ИдФайлУв);
				РегламентированнаяОтчетность.УдалитьУзел(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_ИдОбъект, "СведАкт"));
			КонецЕсли;
		Иначе
			РегламентированнаяОтчетность.УдалитьУзел(Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_СведОбТорг, "ИдОбъект"));
		КонецЕсли;
		
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОбТорг, "Индекс", СтрСвед.ИНДЕКС);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОбТорг, "КодРегион", СтрСвед.КОД_РЕГИОНА);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОбТорг, "Район", СтрСвед.РАЙОН);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОбТорг, "Город", СтрСвед.ГОРОД);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОбТорг, "НаселПункт", СтрСвед.НАСЕЛЕННЫЙ_ПУНКТ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОбТорг, "Улица", СтрСвед.УЛИЦА);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОбТорг, "Дом", СтрСвед.ДОМ);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОбТорг, "Корпус", СтрСвед.КОРПУС);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_АдрОбТорг, "Кварт", СтрСвед.КВАРТИРА);
		
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_РасчСумСбор, "СумЛьгот", СтрСвед.СуммаЛьготы);
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_РасчСумСбор, "КодЛьгот", СтрСвед.КодЛьготы);
		
		Если ЗначениеЗаполнено(СтрСвед.СтавкаСбораРуб) Тогда
			Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_РасчСумСбор, "ИсчислКв", СтрСвед.СтавкаСбораРуб);
			Итог = СтрСвед.СтавкаСбораРуб - СтрСвед.СуммаЛьготы;
			Если Итог < 0 Тогда 
				Итог = 0;
			КонецЕсли;
			Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_РасчСумСбор, "СумСборКв", Итог);
			Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_РасчСумСбор, "СтавкаОбТорг", СтрСвед.СтавкаСбораРуб);
		ИначеЕсли ЗначениеЗаполнено(СтрСвед.СтавкаСбораКвм) Тогда
			Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_РасчСумСбор, "ИсчислКв", Окр(СтрСвед.СтавкаСбораКвм*СтрСвед.ПлощТоргЗала, 0, РежимОкругления.Окр15как20));
			Итог = Окр(СтрСвед.СтавкаСбораКвм*СтрСвед.ПлощТоргЗала, 0, РежимОкругления.Окр15как20) - СтрСвед.СуммаЛьготы;
			Если Итог < 0 Тогда 
				Итог = 0;
			КонецЕсли;
			Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_РасчСумСбор, "СумСборКв", Итог);
			Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_РасчСумСбор, "СтавкаКвМ", СтрСвед.СтавкаСбораКвм);
		КонецЕсли;
	КонецЦикла;
	РегламентированнаяОтчетность.УдалитьУзел(Узел_ОбТоргСбор);
КонецПроцедуры

Функция ПустаяТаблицаСведения()
	ТЗ = Новый ТаблицаЗначений;
	
	ТЗ.Колонки.Добавить("UID");
	ТЗ.Колонки.Добавить("П_ИНН1");
	ТЗ.Колонки.Добавить("П_КПП1");
	ТЗ.Колонки.Добавить("ИНДЕКС");
	ТЗ.Колонки.Добавить("КОД_РЕГИОНА");
	ТЗ.Колонки.Добавить("РАЙОН");
	ТЗ.Колонки.Добавить("ГОРОД");
	ТЗ.Колонки.Добавить("НАСЕЛЕННЫЙ_ПУНКТ");
	ТЗ.Колонки.Добавить("УЛИЦА");
	ТЗ.Колонки.Добавить("ДОМ");
	ТЗ.Колонки.Добавить("КОРПУС");
	ТЗ.Колонки.Добавить("КВАРТИРА");
	ТЗ.Колонки.Добавить("ДАТА_ПРАВА");
	ТЗ.Колонки.Добавить("КодВидаПД");
	ТЗ.Колонки.Добавить("ОКТМО");
	ТЗ.Колонки.Добавить("КодВидаТоргОбъекта");
	ТЗ.Колонки.Добавить("НаимТоргОб");
	ТЗ.Колонки.Добавить("НомерРазр");
	ТЗ.Колонки.Добавить("НомЗдание");
	ТЗ.Колонки.Добавить("НомПомещ");
	ТЗ.Колонки.Добавить("НомУч");
	ТЗ.Колонки.Добавить("ПлощТоргЗала");
	ТЗ.Колонки.Добавить("СтавкаСбораРуб");
	ТЗ.Колонки.Добавить("СтавкаСбораКвм");
	ТЗ.Колонки.Добавить("ИсчСуммаСбора");
	ТЗ.Колонки.Добавить("СуммаЛьготы");
	ТЗ.Колонки.Добавить("СуммаСбораИтого");
	ТЗ.Колонки.Добавить("КодЛьготы");
	ТЗ.Колонки.Добавить("ОснИсп");
	ТЗ.Колонки.Добавить("ДатаАкт");
	ТЗ.Колонки.Добавить("НомерАкт");
	ТЗ.Колонки.Добавить("НомОбъектУв");
	ТЗ.Колонки.Добавить("ИдФайлУв");
	ТЗ.Колонки.Добавить("ИспользоватьФайлАкт");
	
	Возврат ТЗ;
КонецФункции

Функция СоздатьНовыйТС1()
	ДокОбъект = Документы.УведомлениеОСпецрежимахНалогообложения.СоздатьДокумент();
	ДокОбъект.ИмяФормы = "Форма2015_1";
	ДокОбъект.ИмяОтчета = "РегламентированноеУведомлениеТС1";
	ДокОбъект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.ФормаТС1;
	Возврат ДокОбъект;
КонецФункции

Процедура ЗаполнитьДаннымиТС1(ДокОбъект, Выборка)
	ПоказателиОтчета = Выборка.ДанныеОтчета.Получить().ПоказателиОтчета.ПолеТабличногоДокументаТитульный;
	Сведения = ПустаяТаблицаСведения();
	Информация = Выборка.ДанныеОтчета.Получить().ДанныеМногостраничныхРазделов.Информация;
	
	ДокОбъект.Организация = Выборка.Организация;
	ДокОбъект.ДатаПодписи = Выборка.ДатаПодписи;
	ДокОбъект.Дата = Выборка.Дата;
	
	СтрокаСум = "";
	Для Инд = 1 По 4 Цикл 
		СтрокаСум = СтрокаСум + ПоказателиОтчета["НалоговыйОрган" + Инд];
	КонецЦикла;
	ДокОбъект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Выборка.Организация, , СтрокаСум);
	
	Попытка
		Подписант = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПоказателиОтчета.ОргПодписант, " ");
		ДокОбъект.ПодписантФамилия = Подписант[0];
		ДокОбъект.ПодписантИмя = Подписант[1];
		ДокОбъект.ПодписантОтчество = Подписант[2];
	Исключение
		Ошибка = ИнформацияОбОшибке();
		СтрОш = НСтр("ru = 'Не удалось получить ФИО подписанта'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СтрОш, УровеньЖурналаРегистрации.Предупреждение,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
		
	ДокОбъект.ПодписантТелефон = ПоказателиОтчета.ТелефонПодписанта;
	ДокОбъект.ПодписантПризнак = ПоказателиОтчета.ПрПодп;
	
	СтруктураПараметров = Новый Структура("Титульный");
	СтруктураПараметров.Вставить("КОД_НО", СтрЗаменить(СтрокаСум, "-", ""));
	СтрокаСум = "";
	Для Инд = 1 По 12 Цикл 
		СтрокаСум = СтрокаСум + ПоказателиОтчета["ИНН1_" + Инд];
	КонецЦикла;
	ИННТитульный = СтрЗаменить(СтрокаСум, "-", "");
	СтруктураПараметров.Вставить("П_ИНН", ИННТитульный);
	СтрокаСум = "";
	Для Инд = 1 По 9 Цикл 
		СтрокаСум = СтрокаСум + ПоказателиОтчета["КПП1_" + Инд];
	КонецЦикла;
	КППТитульный = СтрЗаменить(СтрокаСум, "-", "");
	СтруктураПараметров.Вставить("П_КПП", КППТитульный);
	
	СтрокаСум = "";
	Для Инд = 1 По 3 Цикл 
		СтрокаСум = СтрокаСум + ПоказателиОтчета["Прил" + Инд];
	КонецЦикла;
	ОТ = Новый ОписаниеТипов("Число");
	СтруктураПараметров.Вставить("ПРИЛОЖЕНО_ЛИСТОВ", ОТ.ПривестиЗначение(СтрЗаменить(СтрокаСум, "-", "")));
	
	СтруктураПараметров.Вставить("UID", Новый УникальныйИдентификатор);
	СтруктураПараметров.Вставить("ОГРН", ПоказателиОтчета.ОГРН);
	СтруктураПараметров.Вставить("ОГРНИП", ПоказателиОтчета.ОГРНИП);
	СтруктураПараметров.Вставить("НАИМЕНОВАНИЕ_ОРГАНИЗАЦИИ", ПоказателиОтчета.НаимОрг);
	СтруктураПараметров.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПоказателиОтчета.ПрПодп);
	СтруктураПараметров.Вставить("КодПричины", ПоказателиОтчета.ПрУведомления);
	КодПричины = ПоказателиОтчета.ПрУведомления;
	
	СтруктураПараметров.Вставить("ИНН_ПОДПИСАНТА", ПоказателиОтчета.ИННПодписанта);
	СтруктураПараметров.Вставить("EMAIL_ПОДПИСАНТА", ПоказателиОтчета.ЭлектроннаяПочтаПодписанта);
	СтруктураПараметров.Вставить("ТЕЛЕФОН", ПоказателиОтчета.ТелефонПодписанта);
	СтруктураПараметров.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПоказателиОтчета.ОргПодписант);
	СтруктураПараметров.Вставить("ДАТА_ПОДПИСИ", Выборка.ДатаПодписи);
	СтруктураПараметров.Вставить("ДОКУМЕНТ_ПРЕДСТАВИТЕЛЯ", ПоказателиОтчета.ДокУпПред);
	СтруктураПараметров.Вставить("ОРГ_ПРЕДСТАВИТЕЛЬ", ПоказателиОтчета.ОргУп);
	СтруктураПараметров.Вставить("КОЛИЧЕСТВО_СТРАНИЦ", 1 + Информация.Количество());
	
	ТЗ = Новый ТаблицаЗначений;
	Для Каждого КЗ Из СтруктураПараметров Цикл 
		ТЗ.Колонки.Добавить(КЗ.Ключ);
	КонецЦикла;
	ТЗ0 = ТЗ.Добавить();
	ЗаполнитьЗначенияСвойств(ТЗ0, СтруктураПараметров);
	
	ОТ = Новый ОписаниеТипов("Число");
	Для Каждого Стр Из Информация Цикл 
		НовСтр = Сведения.Добавить();
		Данные = Стр.Данные;
		
		НовСтр.UID = Новый УникальныйИдентификатор;
		НовСтр.П_ИНН1 = ИННТитульный;
		НовСтр.П_КПП1 = КППТитульный;
		НовСтр.ДАТА_ПРАВА = Данные.П000010010101;
		НовСтр.КодВидаПД = Данные.П000010010201;
		НовСтр.ОКТМО = Данные.П000010020101;
		НовСтр.КодВидаТоргОбъекта = Данные.П000010020201;
		НовСтр.НаимТоргОб = Данные.П000010020301;
		НовСтр.ИНДЕКС = Данные.П000010020401;
		НовСтр.КОД_РЕГИОНА = Данные.П000010020402;
		НовСтр.РАЙОН = Данные.П000010020403;
		НовСтр.ГОРОД = Данные.П000010020404;
		НовСтр.НАСЕЛЕННЫЙ_ПУНКТ = Данные.П000010020405;
		НовСтр.УЛИЦА = Данные.П000010020406;
		НовСтр.ДОМ = Данные.П000010020407;
		НовСтр.КОРПУС = Данные.П000010020408;
		НовСтр.КВАРТИРА = Данные.П000010020409;
		НовСтр.ОснИсп = Данные.П000010020501;
		НовСтр.НомерРазр = Данные.П000010020601;
		НовСтр.НомЗдание = Данные.П000010020701;
		НовСтр.НомПомещ = Данные.П000010020801;
		НовСтр.НомУч = Данные.П000010020901;
		НовСтр.ПлощТоргЗала = Данные.П000010021001;
		НовСтр.СтавкаСбораРуб = Данные.П000010030101;
		НовСтр.СтавкаСбораКвм = Данные.П000010030201;
		НовСтр.ИсчСуммаСбора = Данные.П000010030301;
		НовСтр.СуммаЛьготы = Данные.П000010030401;
		НовСтр.КодЛьготы = Данные.П000010030501;
		НовСтр.СуммаСбораИтого = Данные.П000010030601;
		
		НовСтр.ДатаАкт = Данные.ДатаАкт;
		НовСтр.НомерАкт = Данные.НомАкт;
		НовСтр.НомОбъектУв = ОТ.ПривестиЗначение(Данные.НомОбъектУв);
		НовСтр.ИдФайлУв = Данные.ИдФайлУв;
		НовСтр.ИспользоватьФайлАкт = Не (ЗначениеЗаполнено(НовСтр.НомОбъектУв) Или ЗначениеЗаполнено(НовСтр.ИдФайлУв));
		
		Если ЗначениеЗаполнено(НовСтр["СтавкаСбораРуб"]) Тогда
			Знач1 = НовСтр["СтавкаСбораРуб"];
			Знач2 = Знач1 - НовСтр["СуммаЛьготы"];
			Если Знач2 < 0 Тогда 
				Знач2 = 0;
			КонецЕсли;
		Иначе
			Знач1 = НовСтр["ПлощТоргЗала"] * НовСтр["СтавкаСбораКвм"];
			Знач1 = Окр(Знач1, 0, РежимОкругления.Окр15как20);
			Знач2 = Знач1 - НовСтр["СуммаЛьготы"];
			Если Знач2 < 0 Тогда 
				Знач2 = 0;
			КонецЕсли;
		КонецЕсли;
		
		НовСтр["ИсчСуммаСбора"] = Знач1;
		НовСтр["СуммаСбораИтого"] = Знач2;
	КонецЦикла;
	
	ДанныеУведомленияСтруктура = Новый Структура;
	ДанныеУведомленияСтруктура.Вставить("Титульный", ТЗ);
	ДанныеУведомленияСтруктура.Вставить("Сведения", Сведения);
	ДанныеУведомленияСтруктура.Вставить("КодПричины", КодПричины);
	ДанныеУведомленияСтруктура.Вставить("РегОтчет", Выборка.Ссылка);
	
	ДокОбъект.ДанныеУведомления = Новый ХранилищеЗначения(ДанныеУведомленияСтруктура);
КонецПроцедуры

Процедура СоздатьСконвертированныйТС1(Выборка) Экспорт 
	Попытка
		Если Не ОбщегоНазначения.ПодсистемаСуществует("РегламентированнаяОтчетность.СообщенияВКонтролирующиеОрганы.КонвертацияОтчетовПриПереходеС82") Тогда
			Возврат;
		КонецЕсли;
		
		НачатьТранзакцию();
		НовоеУведомление = СоздатьНовыйТС1();
		ЗаполнитьДаннымиТС1(НовоеУведомление, Выборка);
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(НовоеУведомление);
		
		РегОтчет = Выборка.Ссылка.ПолучитьОбъект();
		РегОтчет.Комментарий = "##УведомлениеОСпецрежимахНалогообложения##" + Выборка.Комментарий;
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(РегОтчет);
		
		ЗаписьСоответствия = РегистрыСведений["СоответствиеРегОтчетовУведомлениям"].СоздатьМенеджерЗаписи();
		ЗаписьСоответствия.РегОтчет = РегОтчет;
		ЗаписьСоответствия.Прочитать();
		ЗаписьСоответствия.РегОтчет = РегОтчет;
		ЗаписьСоответствия.Уведомление = НовоеУведомление;
		ЗаписьСоответствия.Записать(Истина);
		
		ЗафиксироватьТранзакцию();
	Исключение
		Если ТранзакцияАктивна() Тогда 
			ОтменитьТранзакцию();
		КонецЕсли;
		Ошибка = ИнформацияОбОшибке();
		СтрОш = НСтр("ru = 'Создание уведомления ТС-1'", ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка());
		ЗаписьЖурналаРегистрации(СтрОш, УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры

#КонецОбласти
#КонецЕсли