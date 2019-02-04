
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
    
    // Инициализация дополнительных свойств для проведения документа
    ПроведениеСерверУТ.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
    
    ДополнительныеСвойства.Вставить("ЭтоНовый",    ЭтоНовый());
	ДополнительныеСвойства.Вставить("РежимЗаписи", РежимЗаписиДокумента);
        
    // Подготовка наборов записей
    ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
    
    РегистрыСведений.пкСостояниеТехники.СформироватьЗаписи(Отказ, РежимПроведения, ЭтотОбъект);
    РегистрыСведений.пкСтатусыТехники.СформироватьЗаписи(Отказ, РежимПроведения, ЭтотОбъект);
        
    //ПроведениеСерверУТ.ЗаписатьНаборыЗаписей(ЭтотОбъект);
                
    ПроведениеСерверУТ.ОчиститьДополнительныеСвойстваДляПроведения(ДополнительныеСвойства);
    
КонецПроцедуры
