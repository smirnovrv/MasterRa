// @strict-types


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
		
	Для Каждого СтрТЧ из Заказы Цикл
		тДата = КонецМесяца(СтрТЧ.Заявка.Дата)+86400*10;//10 дней
		Если Дата>тДата Тогда 
			Сообщение = Новый СообщениеПользователю;
			Сообщение.Текст = "В строке "+СтрТЧ.НомерСтроки+" Заказ с датой большей чем конец месяца + 10 дней";
			Сообщение.Сообщить();
			//Отказ = Истина;
		КонецЕсли;
	КонецЦикла;	
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Движения.ПланируемыеПрочиеЗатраты.Записывать = Истина;
	Для Каждого стр из Заказы цикл
		Движение 				= Движения.ПланируемыеПрочиеЗатраты.Добавить();
		Движение.ВидДвижения    = ВидДвиженияНакопления.Приход;
		Движение.Период 		= Дата;
		Движение.ВидПлатежа     = ВидПлатежа;
		Движение.КодЗаказа      = стр.Заявка.Номер;
		Движение.Месяц          = Период;
		Движение.НомерСтатьи    = НомерСтатьиРасхода;
		Движение.Организация 	= Организация;
		Движение.РасчетныйСчет  = КассаСчет;
		Движение.СтавкаНДС      = Контрагент.СтавкаНДС;
		Движение.Статья         = СтатьяРасходов;
		Движение.Сумма 			= стр.Сумма;
	КонецЦикла;
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	ДокументОплаты = Неопределено;
КонецПроцедуры
