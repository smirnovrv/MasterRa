#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Email(Команда)

	Структура = ПроверитьНаличиеЭлПочтыПользователя(Объект.Испольнитель);

	Если Структура.ЕстьЭлАдрес Тогда

		СтруктураПисьма = Новый Структура;

		Получатели = Новый Массив;
		Получатели.Добавить(Структура.ЭлПочта);

		СтруктураПисьма.Вставить("Получатели", Получатели);
		СтруктураПисьма.Вставить("ТекстПисьма", "Описание: " + Объект.Описание);
		СтруктураПисьма.Вставить("ТемаПисьма", "Новая задача: " + Объект.Наименование);

		ОтправитьПисьмо(СтруктураПисьма);

	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура EmailКомментарий(Команда)
	
	СтруктураАвтор = ПроверитьНаличиеЭлПочтыПользователя(Объект.Автор);
	
	Если СтруктураАвтор.ЕстьЭлАдрес Тогда

		СтруктураПисьма = Новый Структура;

		Если СтруктураАвтор.ЕстьЭлАдрес Тогда
			Получатели = Новый Массив;
			Получатели.Добавить(СтруктураАвтор.ЭлПочта);
			
			Если Объект.Автор <> Объект.Проверяющий Тогда
				СтруктураПроверяющий = ПроверитьНаличиеЭлПочтыПользователя(Объект.Проверяющий);
				Получатели.Добавить(СтруктураПроверяющий.ЭлПочта);
			КонецЕсли;
			
			текСтрока = Элементы.КомментарииИФайлы.ТекущиеДанные;
				
			СтруктураПисьма.Вставить("Получатели", Получатели);
			СтруктураПисьма.Вставить("ТекстПисьма", "Новая задача: " + Объект.Описание);
			СтруктураПисьма.Вставить("ТемаПисьма", "Комментарий " + текСтрока.ИсходныйНомерСтроки + ": " + текСтрока.Комментарий);

			ОтправитьПисьмо(СтруктураПисьма);
		КонецЕсли;

	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура EmailИсполнителю(Команда)
		
	Если ЗначениеЗаполнено(Объект.Испольнитель) Тогда

		СтруктураПисьма = Новый Структура;

		СтруктураИсполнитель = ПроверитьНаличиеЭлПочтыПользователя(Объект.Испольнитель);

		Если СтруктураИсполнитель.ЕстьЭлАдрес Тогда
			Получатели = Новый Массив;
			Получатели.Добавить(СтруктураИсполнитель.ЭлПочта);

			СтруктураПисьма.Вставить("Получатели", Получатели);
			СтруктураПисьма.Вставить("ТекстПисьма", "Новая задача: " + Объект.Описание);
			СтруктураПисьма.Вставить("ТемаПисьма", "Новая задача: " + Объект.Наименование);

			ОтправитьПисьмо(СтруктураПисьма);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОтправитьПисьмо(Структура)
	
	Профиль 				= ПолучитьИнтернетПочтовыйПрофиль();

	Письмо 					= Новый ИнтернетПочтовоеСообщение;

	Текст 					= Письмо.Тексты.Добавить(Структура.ТекстПисьма);
	Текст.ТипТекста 		= ТипТекстаПочтовогоСообщения.ПростойТекст;

	Письмо.Тема 			= Структура.ТемаПисьма;
	Письмо.Отправитель 		= "SharedFormail@yandex.ru";
	Письмо.ИмяОтправителя 	= "Робот";
	
	Для Каждого строкаПолучатели Из Структура.Получатели Цикл
		Письмо.Получатели.Добавить(строкаПолучатели);
	КонецЦикла;

	Почта 					= Новый ИнтернетПочта;
	Попытка
		Почта.Подключиться(Профиль);
	Исключение	
		Текст = "Не удалось подключиться к серверу";
		СообщитьСообщение(Текст);
		Сообщить(ОписаниеОшибки());
	КонецПопытки;

	Попытка
		Почта.Послать(Письмо);
		Текст = "Письмо отправлено";
		СообщитьСообщение(Текст);
	Исключение	
		Текст = "Не удалось отправить письмо";
		СообщитьСообщение(Текст);		
		Сообщить(ОписаниеОшибки());
	КонецПопытки;

	Почта.Отключиться();
КонецПроцедуры

&НаСервере
Процедура СообщитьСообщение(Текст)
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Сообщить();
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПолучитьИнтернетПочтовыйПрофиль()
	
	Профиль = Новый ИнтернетПочтовыйПрофиль;
	Профиль.АдресСервераSMTP 	= "smtp.yandex.ru";
	Профиль.ПользовательSMTP 	= "SharedForMail@yandex.ru";
	Профиль.ПарольSMTP         	= "9gPsUynm";
	Профиль.ИспользоватьSSLSMTP = Истина;
	Профиль.ПортSMTP 			= 465;
	Профиль.АутентификацияSMTP 	= СпособSMTPАутентификации.Login;
	
	Возврат Профиль;
КонецФункции
   
&НаСервере
Функция ПроверитьНаличиеЭлПочтыПользователя(Пользователь)
	
	ЭлПочта = "";
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Сотрудники.ЭлПочта КАК ЭлПочта
		|ИЗ
		|	Справочник.Сотрудники КАК Сотрудники
		|ГДЕ
		|	Сотрудники.Пользователь = &Пользователь";
	
	Запрос.УстановитьПараметр("Пользователь", Пользователь);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ЭлПочта = ВыборкаДетальныеЗаписи.ЭлПочта;	
	КонецЦикла;

	Структура = Новый Структура;
	Если ЗначениеЗаполнено(ЭлПочта) Тогда 
		Структура.Вставить("ЕстьЭлАдрес",Истина);
		Структура.Вставить("ЭлПочта",ЭлПочта);
	Иначе 
		Структура.Вставить("ЕстьЭлАдрес",Ложь);
		Структура.Вставить("ЭлПочта","");
	КонецЕсли;	
	
	Возврат Структура;	
КонецФункции	

&НаКлиенте
Процедура ПередВыполнением(Отказ)
	Объект.Статус = ПредопределенноеЗначение("Перечисление.СтатусыЗадач.Выполнено");	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		
	СформироватьHTML();
	
КонецПроцедуры

&НаСервере
Процедура СформироватьHTML()
	
	сНаименование = "№"+Объект.Номер+" "+Объект.Наименование;
	
	Структура  = Новый Структура("Наименование", сНаименование);
	
	ТекстHTML = ОбщегоНазначенияВызовСервера.СформироватьHTML(Структура);
	
	сТело2 = "";
	
	Для Каждого строкаКоментария из Объект.КомментарииИФайлы Цикл 
		Если ЗначениеЗаполнено(строкаКоментария.Комментарий) Тогда
			сТело2=сТело2 + "<p>";
			сТело2=сТело2 + ОбщегоНазначенияВызовСервера.ПолучитьТекстHTMLДляСворачиваемогоТекста("Комментарий 	"
				+ строкаКоментария.НомерСтроки, строкаКоментария.Комментарий);
			сТело2=сТело2 + "</p>";
		КонецЕсли;
	
		Если ЗначениеЗаполнено(строкаКоментария.СсылкаНаФайл) Тогда
			ТекКартинка = ПолучитьНавигационнуюСсылку(строкаКоментария.СсылкаНаФайл, "ФайлХранилище");
			сТело2=сТело2+"<img src="+ТекКартинка+">";	
		КонецЕсли;		
	КонецЦикла;	
	
	ТекстHTML = ТекстHTML+сТело2;

КонецПроцедуры	

&НаКлиенте
Процедура КомментарииИФайлыВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если Не Поле.Имя = "КомментарииИФайлыСсылкаНаФайл" Тогда
		СтрутураПараметров = Новый Структура;
		текСтрока = Элементы.КомментарииИФайлы.ТекущиеДанные;
		СтрутураПараметров.Вставить("Комментарий", текСтрока.Комментарий);
		ОткрытьФорму("Задача.ЗадачаПользователя.Форма.ФормаКомментария", СтрутураПараметров);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайлы()
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		УИД = Новый УникальныйИдентификатор();
		Оповещение  =  Новый ОписаниеОповещения("ОбработатьВыборФайла",   ЭтотОбъект);
		НачатьПомещениеФайла(Оповещение,   ,   ,   Истина,   УИД);
		//НачатьПомещениеФайлаНаСервер(Оповещение,,,,,УИД);
	Иначе 
		Оповещение = Новый ОписаниеОповещения("ОтветНаВопросЗаписать", ЭтотОбъект);
		ТекстВопроса = "Элемент не записан, Записать?";                            
		ПоказатьВопрос(Оповещение, ТекстВопроса, РежимДиалогаВопрос.ДаНет);	
 	КонецЕсли;	
КонецПроцедуры

&НаКлиенте 
Процедура ОтветНаВопросЗаписать(Результат, ДополнительныеПараметры) Экспорт 
	Если Результат = КодВозвратаДиалога.Да Тогда
		 ЭтотОбъект.Записать();
		 ДобавитьФайлы();
	КонецЕсли;
КонецПроцедуры 

&НаСервере 
Функция  ПолучитьЗапасыИзХранилища(АдресВХранилище)
        Комментарий =ПолучитьИзВременногоХранилища(АдресВХранилище);		
		Возврат Комментарий;
КонецФункции

&НаКлиенте
Процедура ОбработатьВыборФайла(Результат, Адрес, ВыбранноеИмяФайла, ДополнительныеПараметры) Экспорт
	Если Не Результат Тогда
		Возврат; 
	КонецЕсли;
	
	//Записать();
	
	//Получим данные файла
	ОписаниеФайла = Новый Файл(ВыбранноеИмяФайла);

	//Сохраним в справочник ХранилищеФайлов
	СохранитьФайлВХранилище(Адрес,Объект.Ссылка,ОписаниеФайла.ИмяБезРасширения, Элементы.КомментарииИФайлы.ТекущаяСтрока);	
 	
	ЭтаФорма.Прочитать();

	СформироватьHTML();

КонецПроцедуры

&НаСервере
Процедура СохранитьФайлВХранилище(Адрес,Владелец,Имя,номСтрокиТЧ)  	
	Структура = Новый Структура;
	Структура.Вставить("Владелец",Владелец);
	Структура.Вставить("Имя",Имя);
	
	Существует = ПроверитьУникальность(Структура);
	
	Если Существует Тогда 
		Сообщить("Файл существует, добавьте другой");
	Иначе 
		НовФайл = Справочники.ЗадачаПользователяФайлы.СоздатьЭлемент();
		НовФайл.ВладелецФайла 	= Владелец;
		НовФайл.Наименование 	= Имя;
		НовФайл.ДанныеТекущаяДата = ТекущаяДата();
		НовФайл.ФайлХранилище = Новый ХранилищеЗначения(ПолучитьИзВременногоХранилища(Адрес));
		НовФайл.Записать();
	КонецЕсли;
КонецПроцедуры 

&НаСервере
Функция ПроверитьУникальность(Структура)
	
	Существует = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ЗадачаПользователяФайлы.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.ЗадачаПользователяФайлы КАК ЗадачаПользователяФайлы
		|ГДЕ
		|	ЗадачаПользователяФайлы.ВладелецФайла = &ВладелецФайла
		|	И ЗадачаПользователяФайлы.Наименование = &Наименование";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Структура.Владелец);
	Запрос.УстановитьПараметр("Наименование", Структура.Имя);
	
	РезультатЗапроса = Запрос.Выполнить();

	Существует = Не РезультатЗапроса.Пустой();
	
	Возврат Существует;
	
КонецФункции
	
&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ТекущийКомментарий"  Тогда
		Если ЗначениеЗаполнено(Параметр) Тогда
			текСтрока = Элементы.КомментарииИФайлы.ТекущиеДанные;
			текСтрока.Комментарий = ПолучитьЗапасыИзХранилища(Параметр);
			Модифицированность = Истина; 
			
			СформироватьHTML();
			
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьФайл(Команда)
	ДобавитьФайлы();
КонецПроцедуры
