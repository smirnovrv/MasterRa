// @strict-types


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.Рулоны.Записывать = Истина;
	
	для Каждого стрТЧ из Материалы цикл
		Разница = стрТЧ.ОстатокПоДокументу-стрТЧ.ОстатокФакт;
		Если Разница>0 Тогда			
			Движение = Движения.Рулоны.Добавить();
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Расход;
			Движение.Количество 	= Разница;
			Движение.Материал   	= стрТЧ.Материал;
			Движение.МатериалОсновы = стрТЧ.МатериалОсновы;
			Движение.Период     	= Дата;
			Движение.Регистратор 	= Ссылка;
			Движение.Рулон          = стрТЧ.Рулон;
		ИначеЕсли Разница<0 Тогда
			Движение = Движения.Рулоны.Добавить();
			Движение.ВидДвижения 	= ВидДвиженияНакопления.Приход;
			Движение.Количество 	= -Разница;
			Движение.Материал   	= стрТЧ.Материал;
			Движение.МатериалОсновы = стрТЧ.МатериалОсновы;
			Движение.Период     	= Дата;
			Движение.Регистратор 	= Ссылка;
			Движение.Рулон          = стрТЧ.Рулон;
		КонецЕсли;	
	КонецЦикла;
	Движения.Записать();
			
КонецПроцедуры
