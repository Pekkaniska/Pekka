#Область СлужебныеПроцедурыИФункции

Процедура ЗаполнитьПризнакВыплачиваетсяФСССуществующихДокументов(МенеджерВременныхТаблиц) Экспорт
	
	ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ЗаполнитьПризнакВыплачиваетсяФСССуществующихДокументов(МенеджерВременныхТаблиц);
	
КонецПроцедуры

Функция КатегорииНачисленийПособийПоПрямымВыплатамФСС() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.КатегорииНачисленийПособийПоПрямымВыплатамФСС();
	
КонецФункции

#Область ЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов

Функция ДанныеЗаполненияЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов(Документ, ОплатаДнейУходаЗаДетьмиИнвалидами) Экспорт
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ДанныеЗаполненияЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов(Документ, ОплатаДнейУходаЗаДетьмиИнвалидами);
КонецФункции

Функция ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииВыплатРодителямДетейИнвалидов();
	
КонецФункции

Функция ИспользуетсяЗаполнениеДокументаЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ИспользуетсяЗаполнениеДокументаЗаявлениеВФССОВозмещенииВыплатРодителямДетейИнвалидов();
	
КонецФункции

#КонецОбласти

#Область ЗаявлениеВФССОВозмещенииРасходовНаПогребение

Функция ДанныеЗаполненияЗаявленияВФССОВозмещенииРасходовНаПогребение(Организация, Ссылка, ЕдиновременноеПособие = Неопределено) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ДанныеЗаполненияЗаявленияВФССОВозмещенииРасходовНаПогребение(Организация, Ссылка, ЕдиновременноеПособие);
	
КонецФункции

Функция ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииРасходовНаПогребение() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ОписаниеФиксацииРеквизитовЗаявленияВФССОВозмещенииРасходовНаПогребение();
	
КонецФункции

Функция ИспользуетсяЗаполнениеЗаявленияВФССОВозмещенииРасходовНаПогребение() Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ИспользуетсяЗаполнениеЗаявленияВФССОВозмещенииРасходовНаПогребение();
	
КонецФункции

#КонецОбласти

#Область ЗаявлениеСотрудникаНаВыплатуПособия

Функция БанковскиеРеквизитыСотрудникаДляВыплатыЗарплаты(Дата, Организация, Сотрудник, ФизическоеЛицо) Экспорт
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.БанковскиеРеквизитыСотрудникаДляВыплатыЗарплаты(Дата, Организация, Сотрудник, ФизическоеЛицо);
КонецФункции

Функция РайонныйКоэффициентРФПодразделенияОрганизацииДляЗаявленияСотрудникаНаВыплатуПособия(Организация, Подразделение = Неопределено) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.РайонныйКоэффициентРФПодразделенияОрганизацииДляЗаявленияСотрудникаНаВыплатуПособия(Организация, Подразделение);
	
КонецФункции

Функция ТипДокументаОснованияЗаявленияСотрудникаНаВыплатуПособия(Заявление) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ТипДокументаОснованияЗаявленияСотрудникаНаВыплатуПособия(Заявление);
	
КонецФункции

Функция СписокДетейПоУходуЗаКоторымиПредоставленОтпуск(ДокументОснование) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.СписокДетейПоУходуЗаКоторымиПредоставленОтпуск(ДокументОснование);
	
КонецФункции

Функция ВидПособияИмеетДокументОснование(ВидПособия) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ВидПособияИмеетДокументОснование(ВидПособия);
	
КонецФункции

Функция ДоляРабочегоВремениСотрудника(Сотрудник, Дата) Экспорт
	
	Возврат ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ДоляРабочегоВремениСотрудника(Сотрудник, Дата);
	
КонецФункции

Процедура ДобавитьКомандыПечатиЗаявленияСотрудникаНаВыплатуПособия(КомандыПечати) Экспорт
	
	ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ДобавитьКомандыПечатиЗаявленияСотрудникаНаВыплатуПособия(КомандыПечати);
	
КонецПроцедуры

#КонецОбласти

#Область РеестрСведенийНеобходимыхДляНазначенияИВыплатыПособий

Процедура ПриОпределенииЗапросаРеестраПрямыхВыплатПоПервичнымДокументам(Запрос, Объект, ТаблицаОснований) Экспорт
	
	ПрямыеВыплатыПособийСоциальногоСтрахованияРасширенный.ПриОпределенииЗапросаРеестраПрямыхВыплатПоПервичнымДокументам(Запрос, Объект, ТаблицаОснований);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
