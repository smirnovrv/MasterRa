// @strict-types


&НаСервере
Процедура Команда1НаСервере()
	
	Пустая_ТЧ_Стоимости.Очистить();
	ОдинаковыеСтроки_ТЧ_Стоимости.Очистить();
	
	Выборка = Документы.Заявка.Выбрать(НачалоГода(ТекущаяДата()),,,);
	
	Пока Выборка.Следующий() Цикл 
		Если Выборка.ПометкаУдаления Тогда 
			Продолжить;
		КонецЕсли;	
		Если Выборка.Стоимости.Количество()=0 Тогда 
			Пустая_ТЧ_Стоимости.Добавить(Выборка.Ссылка);
		иначе
			ТЧ = Выборка.Стоимости.Выгрузить();
			Для Каждого СтрТЧ из Выборка.Стоимости Цикл 
				Отбор = Новый Структура;
				Отбор.Вставить("Работы",СтрТЧ.Работы);
				кол = ТЧ.НайтиСтроки(Отбор);
				Если кол.Количество()>1 Тогда 
					ОдинаковыеСтроки_ТЧ_Стоимости.Добавить(Выборка.Ссылка);	
				КонецЕсли;	
			КонецЦикла;		
		КонецЕсли;	
	КонецЦикла;	

КонецПроцедуры

&НаКлиенте
Процедура Команда1(Команда)
	Команда1НаСервере();
КонецПроцедуры
