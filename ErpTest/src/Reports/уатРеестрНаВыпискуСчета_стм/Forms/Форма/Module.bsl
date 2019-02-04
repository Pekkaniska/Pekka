// Основная процедура формирования отчета.
//Формирует отчет в виде табличного документа.
//
//Параметры:
//	ТабДок - табличный документ, куда будет выведен отчет,
//	АЗС, Организация - Отборы по АЗС и Организации,
//	ДатаКон, ДатаНач - период формирования отчета.
//
&НаСервере
Процедура СформироватьОтчетСервер()
	ТабДок.Очистить();         
	Макет = Отчеты.уатРеестрНаВыпискуСчета_стм.ПолучитьМакет("Отчет");
		
	Запрос1 = Новый Запрос;      // запрос по параметрам выработки
	
	Запрос1.Текст = 
	"ВЫБРАТЬ
	|	уатВыработкаПоСтоимостиОбороты.ПараметрВыработки КАК ПараметрВыработки,
	|	уатВыработкаПоСтоимостиОбороты.НоменклатураУслуги.ЕдиницаИзмерения КАК ЕдиницаИзмерения
	|ИЗ
	|	РегистрНакопления.уатВыработкаПоСтоимости.Обороты(&ДатаНач, &ДатаКон, , Контрагент = &Контрагент";
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос1.Текст = Запрос1.Текст+"
		|			И Организация = &Организация";
	КонецЕсли;
	
	Запрос1.Текст = Запрос1.Текст+"
	|) КАК уатВыработкаПоСтоимостиОбороты
	|ГДЕ 
	|	(&ТСВыбыло ИЛИ уатВыработкаПоСтоимостиОбороты.ТС.уатДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1))
	|		
	|СГРУППИРОВАТЬ ПО
	|	уатВыработкаПоСтоимостиОбороты.ПараметрВыработки,
	|	уатВыработкаПоСтоимостиОбороты.НоменклатураУслуги.ЕдиницаИзмерения";
	
	Запрос1.УстановитьПараметр("ДатаНач", ДатаНач);
	Запрос1.УстановитьПараметр("ДатаКон", ДатаКон);
	Запрос1.УстановитьПараметр("Контрагент", Контрагент);
	Запрос1.УстановитьПараметр("ТСВыбыло", ВыбывшиеТС);
	
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос1.УстановитьПараметр("Организация", Организация);
	КонецЕсли;
	
	Результат1 = Запрос1.Выполнить();
	ТЗ=Результат1.Выгрузить();
	ТЗ.Колонки.Добавить("ИтогАвто",Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("ИтогОбъект",Новый ОписаниеТипов("Число"));
	ТЗ.Колонки.Добавить("ИтогОбщий",Новый ОписаниеТипов("Число"));
	ТЗ.ЗаполнитьЗначения(0,"ИтогОбщий");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	уатВыработкаПоСтоимостиОбороты.ТС КАК ТС,
	|	ПРЕДСТАВЛЕНИЕ(уатВыработкаПоСтоимостиОбороты.ТС),
	|	уатВыработкаПоСтоимостиОбороты.ПутЛист,
	|	уатВыработкаПоСтоимостиОбороты.ПараметрВыработки КАК ПараметрВыработки,
	|	ПРЕДСТАВЛЕНИЕ(уатВыработкаПоСтоимостиОбороты.ПараметрВыработки),
	|	ВЫБОР
	|		КОГДА уатВыработкаПоСтоимостиОбороты.ПараметрВыработки = &ПараметрВыработки_ВремяВРаботе
	|				ИЛИ уатВыработкаПоСтоимостиОбороты.ПараметрВыработки = &ПараметрВыработки_ВремяВНаряде
	|				ИЛИ уатВыработкаПоСтоимостиОбороты.ПараметрВыработки = &ПараметрВыработки_ВремяВПростое
	|			ТОГДА -РАЗНОСТЬДАТ(ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0), ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0), СЕКУНДА, уатВыработкаПоСтоимостиОбороты.КоличествоПараметрВыработкиОборот), ЧАС) * 3600 / 6000 + уатВыработкаПоСтоимостиОбороты.КоличествоПараметрВыработкиОборот / 6000 + РАЗНОСТЬДАТ(ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0), ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0), СЕКУНДА, уатВыработкаПоСтоимостиОбороты.КоличествоПараметрВыработкиОборот), ЧАС)
	|		ИНАЧЕ уатВыработкаПоСтоимостиОбороты.КоличествоПараметрВыработкиОборот
	|	КОНЕЦ КАК КоличествоОборот,
	|	уатВыработкаПоСтоимостиОбороты.СуммаВзаиморасчетовОборот КАК СуммаВзаиморасчетовОборот,
	|	уатВыработкаПоСтоимостиОбороты.СуммаНДСОборот КАК СуммаНДСОборот,
	|	уатВыработкаПоСтоимостиОбороты.ОбъектСтроительства КАК ОбъектСтроительства,
	|	ПРЕДСТАВЛЕНИЕ(уатВыработкаПоСтоимостиОбороты.ОбъектСтроительства),
	|	уатВыработкаПоСтоимостиОбороты.СуммаВзаиморасчетовОборот - уатВыработкаПоСтоимостиОбороты.СуммаНДСОборот КАК СуммаБезНДС
	|ИЗ
	|	РегистрНакопления.уатВыработкаПоСтоимости.Обороты(
	|		&ДатаНач,
	|		&ДатаКон,
	|		,
	|		Контрагент = &Контрагент";
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос.Текст = Запрос.Текст+"
		|			И Организация = &Организация";
	КонецЕсли;
	Запрос.Текст = Запрос.Текст+"
	|) КАК уатВыработкаПоСтоимостиОбороты
	|ГДЕ 
	|	(&ТСВыбыло ИЛИ уатВыработкаПоСтоимостиОбороты.ТС.уатДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1))
	|
	|ИТОГИ
	|	СУММА(КоличествоОборот),
	|	СУММА(СуммаВзаиморасчетовОборот),
	|	СУММА(СуммаБезНДС),
	|	СУММА(СуммаНДСОборот)
	|ПО
	|	ОБЩИЕ,
	|	ОбъектСтроительства,
	|	ТС,
	|	ПараметрВыработки";
	
	Запрос.УстановитьПараметр("ДатаКон", ДатаКон);
	Запрос.УстановитьПараметр("ДатаНач", ДатаНач);
	Запрос.УстановитьПараметр("Контрагент", Контрагент);
	Запрос.УстановитьПараметр("ТСВыбыло", ВыбывшиеТС);
	Если ЗначениеЗаполнено(Организация) Тогда
		Запрос.УстановитьПараметр("Организация",Организация );
	КонецЕсли;
	Запрос.УстановитьПараметр("ПараметрВыработки_ВремяВНаряде", Справочники.уатПараметрыВыработки.ВремяВНаряде);
	Запрос.УстановитьПараметр("ПараметрВыработки_ВремяВРаботе", Справочники.уатПараметрыВыработки.ВремяВРаботе);
	Запрос.УстановитьПараметр("ПараметрВыработки_ВремяВПростое", Справочники.уатПараметрыВыработки.ВремяВПростое);
	
	Результат = Запрос.Выполнить();
	
	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапка1Таблицы = Макет.ПолучитьОбласть("Шапка1Таблицы");
	ОбластьШапка2Таблицы = Макет.ПолучитьОбласть("Шапка2Таблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьОбщийИтог1 = Макет.ПолучитьОбласть("ОбщиеИтоги1");
	ОбластьОбщийИтог2 = Макет.ПолучитьОбласть("ОбщиеИтоги2");
	ОбластьОбъектСтроительстваЗаголовок = Макет.ПолучитьОбласть("ОбъектСтроительства");
	ОбластьОбъектСтроительства1 = Макет.ПолучитьОбласть("ОбъектСтроительства1");
	ОбластьТС1 = Макет.ПолучитьОбласть("ТС1");
	ОбластьТС2 = Макет.ПолучитьОбласть("ТС2");
	ОбластьТС3 = Макет.ПолучитьОбласть("ТС3");
	ОбластьДетальныхЗаписей1 = Макет.ПолучитьОбласть("Детали1");
	ОбластьДетальныхЗаписей2 = Макет.ПолучитьОбласть("Детали2");
	ОбластьДетальныхЗаписей3 = Макет.ПолучитьОбласть("Детали3");
	ОбластьПусто = Макет.ПолучитьОбласть("Пусто");
	
	ОбластьЗаголовок.Параметры.ДатаКон=ДатаКон;
	ОбластьЗаголовок.Параметры.Контрагент=Контрагент.НаименованиеПолное;
	ОбластьЗаголовок.Параметры.Исполнитель= Организация.НаименованиеПолное;
	ОбластьЗаголовок.Параметры.Период=ПредставлениеПериода(НачалоДня(ДатаНач), КонецДня(ДатаКон), "ФП = Истина");
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапка1Таблицы);
	
	ОбластьШапкаПараметрыВыработки=Макет.ПолучитьОбласть("ПараметрыВыработки");
	Выборка1=Результат1.Выбрать();
	
	Пока Выборка1.Следующий() Цикл
		ОбластьШапкаПараметрыВыработки.Параметры.ПараметрВыработки=""+Выборка1.ПараметрВыработки+", "+Выборка1.ЕдиницаИзмерения; 
		ТабДок.Присоединить(ОбластьШапкаПараметрыВыработки);  // Шапка
	КонецЦикла;
	
	ТабДок.Присоединить(ОбластьШапка2Таблицы);             // с шапкой закончили
	
	ТабДок.НачатьАвтогруппировкуСтрок();
	
	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ВыборкаОбщийИтог.Следующий();		// Общий итог
	
	ВыборкаОбъектСтроительства = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	ТЗ.ЗаполнитьЗначения(0,"ИтогОбъект");
	
	Если уатОбщегоНазначенияТиповые.уатЕстьИзмерениеРегистра("ОбъектСтроительства", РегистрыНакопления.уатВыработкаПоСтоимости) Тогда
		
		Пока ВыборкаОбъектСтроительства.Следующий() Цикл       // цикл по объекту строительства
			ОбластьОбъектСтроительстваЗаголовок.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Вывести(ОбластьОбъектСтроительстваЗаголовок, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Вывести(ОбластьОбъектСтроительстваЗаголовок, 1);
			
			ВыборкаТС = ВыборкаОбъектСтроительства.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			ТЗ.ЗаполнитьЗначения(0,"ИтогОбъект");
			
			Пока ВыборкаТС.Следующий() Цикл                    // цикл по автомобилям
				ВыборкаПараметрВыработки = ВыборкаТС.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				ТЗ.ЗаполнитьЗначения(0,"ИтогАвто");
				Пока ВыборкаПараметрВыработки.Следующий() Цикл
					ВыборкаДетали = ВыборкаПараметрВыработки.Выбрать();
					
					Пока ВыборкаДетали.Следующий() Цикл       // цикл по путевым листам
						ОбластьДетальныхЗаписей1.Параметры.Номер = ВыборкаДетали.ПутЛист.Номер;
						ОбластьДетальныхЗаписей1.Параметры.Дата = ВыборкаДетали.ПутЛист.Дата;
						ОбластьДетальныхЗаписей1.Параметры.ТС = уатОбщегоНазначения.уатПредставлениеТС(ВыборкаДетали.ТС, ОрганизацияПользователя);
						
						//ТабДок.Вывести(ОбластьДетальныхЗаписей1, ВыборкаДетали.Уровень());
						ТабДок.Вывести(ОбластьДетальныхЗаписей1, 3);
						
						Для ин=0 По ТЗ.Количество()-1 Цикл
							Если ТЗ[ин].ПараметрВыработки=ВыборкаДетали.ПараметрВыработки Тогда
								ОбластьДетальныхЗаписей2.Параметры.Заполнить(ВыборкаДетали);
								
								//ТабДок.Присоединить(ОбластьДетальныхЗаписей2, ВыборкаДетали.Уровень());
								ТабДок.Присоединить(ОбластьДетальныхЗаписей2);
								
								ТЗ[ин].ИтогАвто=ТЗ[ин].ИтогАвто + ВыборкаДетали.КоличествоОборот;
								ТЗ[ин].ИтогОбъект=ТЗ[ин].ИтогОбъект + ВыборкаДетали.КоличествоОборот;
								ТЗ[ин].ИтогОбщий=ТЗ[ин].ИтогОбщий + ВыборкаДетали.КоличествоОборот;
							Иначе
								//ТабДок.Присоединить(ОбластьПусто, ВыборкаДетали.Уровень());
								ТабДок.Присоединить(ОбластьПусто);
								
							КонецЕсли; 
						КонецЦикла; 
						
						ОбластьДетальныхЗаписей3.Параметры.Заполнить(ВыборкаДетали);
						
						//ТабДок.Присоединить(ОбластьДетальныхЗаписей3, ВыборкаДетали.Уровень());
						ТабДок.Присоединить(ОбластьДетальныхЗаписей3);
						
					КонецЦикла;  // по путевым листам
					
				КонецЦикла;      // по параметрам   выработки
				
				ОбластьТС1.Параметры.Заполнить(ВыборкаТС);
				
				//ТабДок.Вывести(ОбластьТС1, ВыборкаТС.Уровень());
				ТабДок.Вывести(ОбластьТС1, 2);
				
				Для ин=0 По ТЗ.Количество()-1 Цикл
					ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогАвто;
					
					//ТабДок.Присоединить(ОбластьТС2, ВыборкаТС.Уровень());
					ТабДок.Присоединить(ОбластьТС2);
					
				КонецЦикла; 
				ОбластьТС3.Параметры.Заполнить(ВыборкаТС);
				
				//ТабДок.Присоединить(ОбластьТС3, ВыборкаТС.Уровень());
				ТабДок.Присоединить(ОбластьТС3);
				
			КонецЦикла; // по автомобилям
			
			ОбластьОбъектСтроительства1.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Вывести(ОбластьОбъектСтроительства1, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Вывести(ОбластьОбъектСтроительства1, 1);
			
			Для ин=0 По ТЗ.Количество()-1 Цикл
				ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогОбъект;
				
				//ТабДок.Присоединить(ОбластьТС2, ВыборкаОбъектСтроительства.Уровень());
				ТабДок.Присоединить(ОбластьТС2);
			КонецЦикла; 
			ОбластьТС3.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Присоединить(ОбластьТС3, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Присоединить(ОбластьТС3);
			
		КонецЦикла;     // по объектам
		
	Иначе
		
		Пока ВыборкаОбъектСтроительства.Следующий() Цикл       // цикл по объекту строительства
			ОбластьОбъектСтроительстваЗаголовок.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			//ТабДок.Вывести(ОбластьОбъектСтроительстваЗаголовок, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Вывести(ОбластьОбъектСтроительстваЗаголовок, 1);
			
			ВыборкаТС = ВыборкаОбъектСтроительства.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			ТЗ.ЗаполнитьЗначения(0,"ИтогОбъект");
			
			Пока ВыборкаТС.Следующий() Цикл                    // цикл по автомобилям
				ВыборкаПараметрВыработки = ВыборкаТС.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
				ТЗ.ЗаполнитьЗначения(0,"ИтогАвто");
				Пока ВыборкаПараметрВыработки.Следующий() Цикл
					ВыборкаДетали = ВыборкаПараметрВыработки.Выбрать();
					
					Пока ВыборкаДетали.Следующий() Цикл       // цикл по путевым листам
						ОбластьДетальныхЗаписей1.Параметры.Номер = ВыборкаДетали.ПутЛист.Номер;
						ОбластьДетальныхЗаписей1.Параметры.Дата = ВыборкаДетали.ПутЛист.Дата;
						ОбластьДетальныхЗаписей1.Параметры.ТС = уатОбщегоНазначения.уатПредставлениеТС(ВыборкаДетали.ТС, ОрганизацияПользователя);
						
						//ТабДок.Вывести(ОбластьДетальныхЗаписей1, ВыборкаДетали.Уровень());
						ТабДок.Вывести(ОбластьДетальныхЗаписей1, 3);
						
						Для ин=0 По ТЗ.Количество()-1 Цикл
							Если ТЗ[ин].ПараметрВыработки=ВыборкаДетали.ПараметрВыработки Тогда
								ОбластьДетальныхЗаписей2.Параметры.Заполнить(ВыборкаДетали);
								
								//ТабДок.Присоединить(ОбластьДетальныхЗаписей2, ВыборкаДетали.Уровень());
								ТабДок.Присоединить(ОбластьДетальныхЗаписей2);
								
								ТЗ[ин].ИтогАвто=ТЗ[ин].ИтогАвто + ВыборкаДетали.КоличествоОборот;
								ТЗ[ин].ИтогОбъект=ТЗ[ин].ИтогОбъект + ВыборкаДетали.КоличествоОборот;
								ТЗ[ин].ИтогОбщий=ТЗ[ин].ИтогОбщий + ВыборкаДетали.КоличествоОборот;
								
							Иначе
								//ТабДок.Присоединить(ОбластьПусто, ВыборкаДетали.Уровень());
								ТабДок.Присоединить(ОбластьПусто);
								
							КонецЕсли; 
						КонецЦикла; 
						
						ОбластьДетальныхЗаписей3.Параметры.Заполнить(ВыборкаДетали);
						ТабДок.Присоединить(ОбластьДетальныхЗаписей3, ВыборкаДетали.Уровень());
						
					КонецЦикла;  // по путевым листам
				КонецЦикла;      // по параметрам   выработки
				ОбластьТС1.Параметры.Заполнить(ВыборкаТС);
				
				//ТабДок.Вывести(ОбластьТС1, ВыборкаТС.Уровень());
				ТабДок.Вывести(ОбластьТС1, 2);
				
				Для ин=0 По ТЗ.Количество()-1 Цикл
					ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогАвто;
					//ТабДок.Присоединить(ОбластьТС2, ВыборкаТС.Уровень());
					ТабДок.Присоединить(ОбластьТС2);
					
				КонецЦикла; 
				
				ОбластьТС3.Параметры.Заполнить(ВыборкаТС);
				//ТабДок.Присоединить(ОбластьТС3, ВыборкаТС.Уровень());
				ТабДок.Присоединить(ОбластьТС3);
				
			КонецЦикла;    // по автомобилям
			
			ОбластьОбъектСтроительства1.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Вывести(ОбластьОбъектСтроительства1, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Вывести(ОбластьОбъектСтроительства1, 1);
			
			Для ин=0 По ТЗ.Количество()-1 Цикл
				ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогОбъект;
				//ТабДок.Присоединить(ОбластьТС2, ВыборкаОбъектСтроительства.Уровень());
				ТабДок.Присоединить(ОбластьТС2);
			КонецЦикла; 
			ОбластьТС3.Параметры.Заполнить(ВыборкаОбъектСтроительства);
			
			//ТабДок.Присоединить(ОбластьТС3, ВыборкаОбъектСтроительства.Уровень());
			ТабДок.Присоединить(ОбластьТС3);
			
		КонецЦикла;     // по объектам
	КонецЕсли;	 
	
	//ТабДок.Вывести(ОбластьОбщийИтог1, ВыборкаОбщийИтог.Уровень());
	ТабДок.Вывести(ОбластьОбщийИтог1, 0);
	
	Для ин=0 По ТЗ.Количество()-1 Цикл
		ОбластьТС2.Параметры.КоличествоОборот=ТЗ[ин].ИтогОбщий;
		
		//ТабДок.Присоединить(ОбластьТС2, ВыборкаОбщийИтог.Уровень());
		ТабДок.Присоединить(ОбластьТС2);
	КонецЦикла; 
	ОбластьОбщийИтог2.Параметры.Заполнить(ВыборкаОбщийИтог);
	
	//ТабДок.Присоединить(ОбластьОбщийИтог2, ВыборкаОбщийИтог.Уровень());
	ТабДок.Присоединить(ОбластьОбщийИтог2);
	
	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ОбластьПодвал.Параметры.Контрагент =Контрагент.НаименованиеПолное;
	ОбластьПодвал.Параметры.Исполнитель = Организация.НаименованиеПолное;
	ТабДок.Вывести(ОбластьПодвал);
	ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_РЕЕСТР";
	ТабДок.ФиксацияСверху = 9;
	ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ  

&НаКлиенте
Процедура НастройкаПериода(Команда)
	ДиалогПериода = Новый ДиалогРедактированияСтандартногоПериода();
	ДиалогПериода.Период.ДатаНачала = ДатаНач;
	ДиалогПериода.Период.ДатаОкончания = ДатаКон;
	ДиалогПериода.Показать(Новый ОписаниеОповещения("НастройкаПериодаЗавершение", ЭтотОбъект, Новый Структура("ДиалогПериода", ДиалогПериода)));
КонецПроцедуры

&НаКлиенте
Процедура НастройкаПериодаЗавершение(Период, ДополнительныеПараметры) Экспорт
    
    Если Не Период = Неопределено Тогда
        ДатаНач = Период.ДатаНачала;
        ДатаКон = Период.ДатаОкончания;
    КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчет(Команда)
	Если НЕ ЗначениеЗаполнено(Контрагент) Тогда
		ПоказатьПредупреждение(, "Не указан Контрагент!");
		Возврат;
	КонецЕсли;
	
	СформироватьОтчетСервер();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаНач = НачалоМесяца(ТекущаяДата());
	ДатаКон = КонецМесяца(ТекущаяДата());
	
	ОрганизацияПользователя = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
			ПользователиКлиентСервер.ТекущийПользователь(), "ОсновнаяОрганизация");
			
	Если НЕ ЗначениеЗаполнено(Организация) Тогда
		Организация = ОрганизацияПользователя;
	КонецЕсли;
КонецПроцедуры
