// @strict-types
&НаКлиенте
Процедура ОткрытьМастер(Команда)
	ОткрытьФорму("Обработка.МастерПоСозданиюКартыЗаказа.Форма");
КонецПроцедуры

&НаКлиенте
Процедура Переделка(Команда)
	
	Источник = ЭтаФорма.ТекущийЭлемент.ТекущаяСтрока;
	Парам = Новый Структура("ЗначениеКопирования",Источник);
	парам.Вставить("Переделка",Истина);
	Форма = ПолучитьФорму("Документ.Заявка.ФормаОбъекта",Парам);
	ДанныеФормы = Форма.Объект;
		
	ДанныеФормы.номер 					= мНомер(Источник);
	ДанныеФормы.Дата 					= ТекущаяДата();
	ДанныеФормы.Переделка				= Истина;
	ДанныеФормы.СрокИзготовленияЗаказа 	= ТекущаяДата(); 
	
	КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
	Форма.Открыть();
	
КонецПроцедуры

Функция мНомер(Источник)
	Возврат Источник.номер;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если РольДоступна("Дизайнер") Тогда 
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.РежимОтображения 	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("ВидРабот");
		ЭлементОтбора.ПравоеЗначение 	= Перечисления.ВидыРабот.Дизайн;
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
	ИначеЕсли РольДоступна("МастерМерч") Тогда 	
		ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ЭлементОтбора.РежимОтображения 	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
		ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Организация");
		ЭлементОтбора.ПравоеЗначение 	= ПараметрыСеанса.ТекущийПользователь.Организация;
		ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
		ЭлементОтбора.Использование 	= Истина;
	Иначе 
		Список.Отбор.Элементы.Очистить();
	КонецЕсли;
КонецПроцедуры
