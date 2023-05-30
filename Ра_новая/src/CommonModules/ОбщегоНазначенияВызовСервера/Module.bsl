// @strict-types

Функция РазложитьСтрокуВМассивПодстрок(Знач Строка, Знач Разделитель = ",") Экспорт
	
	Результат = Новый Массив;
	
	Позиция = Найти(Строка, Разделитель);
	Пока Позиция > 0 Цикл
		Подстрока = Лев(Строка, Позиция - 1);
		Если Не ПустаяСтрока(Подстрока) Тогда
			Результат.Добавить(Подстрока);
		КонецЕсли;
		Строка = Сред(Строка, Позиция + СтрДлина(Разделитель));
		Позиция = Найти(Строка, Разделитель);
	КонецЦикла;
	
	Если Не ПустаяСтрока(Строка) Тогда
		Результат.Добавить(Строка);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции 

Функция ДоступнаРоль(Роль)  Экспорт
	Возврат РольДоступна(Роль);	
КонецФункции

Функция СформироватьНомерЗаявки(Параметр,Основание) Экспорт
	текПользователь = ПараметрыСеанса.ТекущийПользователь;
	Если Основание=Неопределено тогда  //присваиваем следующий номер
		сотрудник = Справочники.Сотрудники.НайтиПоРеквизиту("Пользователь",текПользователь);
		Префикс = сотрудник.Префикс+"/"+прав(Год(ТекущаяДата()),2);
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗначениеНомераГруппы.Номер КАК Номер,
		|	ЗначениеНомераГруппы.Группа,
		|	ЗначениеНомераГруппы.Передел,
		|	ЗначениеНомераГруппы.Префикс
		|ИЗ
		|	РегистрСведений.ЗначениеНомераГруппы КАК ЗначениеНомераГруппы
		|ГДЕ
		|	ЗначениеНомераГруппы.Префикс = &Префикс
		|
		|УПОРЯДОЧИТЬ ПО
		|	Номер УБЫВ";
		
		Запрос.УстановитьПараметр("Префикс", Префикс);
		Результат = Запрос.Выполнить();
		Если результат.Пустой() тогда
			//Первый номер
			записьРег = РегистрыСведений.ЗначениеНомераГруппы.СоздатьМенеджерЗаписи();
			Попытка
				записьРег.Префикс 	= Префикс;
				записьРег.Номер	 	= "0001";
				записьРег.Группа 	= 1;
				записьРег.Передел  	= 0;
				записьРег.Записать();	
			Исключение
				Сообщение = Новый СообщениеПользователю;
				Сообщение.Текст = "Пользователь не сотрудник";
				Сообщение.Сообщить();
			КонецПопытки;
		КонецЕсли; 			
	иначе	
		массив = ОбщегоНазначенияВызовСервера.РазложитьСтрокуВМассивПодстрок(Основание.Номер,"-");
		Префикс = массив.получить(0);
		Номер = массив.получить(1);
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	ЗначениеНомераГруппы.Номер,
		|	ЗначениеНомераГруппы.Группа КАК Группа,
		|	ЗначениеНомераГруппы.Передел,
		|	ЗначениеНомераГруппы.Префикс
		|ИЗ
		|	РегистрСведений.ЗначениеНомераГруппы КАК ЗначениеНомераГруппы
		|ГДЕ
		|	ЗначениеНомераГруппы.Префикс = &Префикс
		|	И ЗначениеНомераГруппы.Номер = &Номер
		|
		|УПОРЯДОЧИТЬ ПО
		|	Группа УБЫВ";
		
		Запрос.УстановитьПараметр("Префикс", Префикс);
		Запрос.УстановитьПараметр("Номер", Номер);
		Результат = Запрос.Выполнить();

	КонецЕсли;	
	мНомер = "";	
	
	Выборка = результат.выбрать();
	Выборка.Следующий();
	Если Параметр="Вгруппе" тогда
		Группа = Выборка.Группа+1;
		мНомер = Выборка.Префикс+"-"+Выборка.номер+"-"+Группа;
		Если  Выборка.Передел>0 Тогда 
			мНомер = Выборка.номер+"-"+Выборка.Передел;
		КонецЕсли;	
	иначеЕсли Параметр="Переделка" тогда
		Передел = Выборка.Передел+1;
		мНомер = Выборка.Префикс+"-"+Выборка.номер+"-"+Выборка.Группа+"-"+Передел;
	иначеЕсли Параметр="Цветопроба" тогда
		Попытка 
			Если Основание=Неопределено Тогда 
				следНомер = Число(Выборка.Номер)+1;
				текНомер = Прав("0000"+СтрЗаменить(Строка(следНомер),Символы.НПП,""),4);
				мНомер = Выборка.Префикс+"-"+текНомер+"-"+0;
			Иначе 
				мНомер = Выборка.Префикс+"-"+Выборка.номер+"-"+0;
			КонецЕсли;
		Исключение
			Если Основание=Неопределено Тогда 
				следНомер = Число(Номер)+1;
				текНомер = Прав("0000"+СтрЗаменить(Строка(следНомер),Символы.НПП,""),4);
				мНомер = Префикс+"-"+текНомер+"-"+0;
			Иначе 
				мНомер = Префикс+"-"+номер+"-"+0;
			КонецЕсли;	
		КонецПопытки;	
	иначе
		Если Выборка.Номер = Неопределено Тогда
			следНомер = 1;
		иначе 
		следНомер = Число(Выборка.Номер)+1;
		КонецЕсли;
		текНомер = Прав("0000"+СтрЗаменить(Строка(следНомер),Символы.НПП,""),4);
		Если  Выборка.Префикс=Неопределено Тогда 
			мНомер = Префикс+"-"+текНомер+"-"+1;
		иначе	
			мНомер = Выборка.Префикс+"-"+текНомер+"-"+1;
		КонецЕсли;
	КонецЕсли;	
	
	Возврат мНомер
	
КонецФункции	

Функция ПолучитьТариф(Структура) Экспорт

	ЗапросТариф = Новый Запрос;
	ЗапросТариф.Текст = 
	"ВЫБРАТЬ
	|	ТарифЦехаСрезПоследних.ПроцентТехника,
	|	ТарифЦехаСрезПоследних.ПроцентПечатника,
	|	ТарифЦехаСрезПоследних.Тариф
	|ИЗ
	|	РегистрСведений.ТарифЦеха.СрезПоследних(
	|			&НаДату,
	|			КолПечатников = &КолПечатников
	|				И КолТехников = &КолТехников) КАК ТарифЦехаСрезПоследних";
	
	ЗапросТариф.УстановитьПараметр("НаДату", Структура.Дата);
	ЗапросТариф.УстановитьПараметр("КолТехников",Структура.счТехник);
	ЗапросТариф.УстановитьПараметр("КолПечатников",Структура.счПечатник);
	
	РезультатТариф 	= ЗапросТариф.Выполнить();

КонецФункции	 

Функция СформироватьHTML(Структура) Экспорт
	
	сЗаголовок1	= "
	|<!DOCTYPE html>
	|<HTML>
	|<HEAD>
	|
	|<script type=""text/javascript"">
	|
	|function showHide(element_id, parent_id) {
	|	
	|
	|	if (document.getElementById(element_id)) { 
	|           var obj = document.getElementById(element_id); 
	|	var parentobj = document.getElementById(parent_id);
	|	   
	| 
	|            if (obj.style.display != ""block"") { 
	|              obj.style.display = ""block""; //Показываем элемент
	|	     parentobj.innerHTML = ""-"";
	|              }
	|              else {obj.style.display = ""none""; //Скрываем элемент
	|		parentobj.innerHTML = ""+"";}
	|              }
	|         
	|         }   
	|</script>
	|
	|<META content=""text/html; charset=utf-8"" http-equiv=Content-Type></META>
	|<meta http-equiv='X-UA-Compatible' content='IE=Edge'>
	|<META name=GENERATOR content=""MSHTML 11.00.9600.17924""></META>
	|</HEAD>
	|"; 
	
	сШапка ="
	|<TABLE width=""100%"">
	|<TBODY>";
	
	сШапка	= сШапка + "
	|	<TR>
	|		<TD class=""title"" width=""50%""> 
	|			<span class=""title_text"">"+Структура.Наименование+"</span>
	|		</TD>  
	|       <TD class=""title"">
	|		</TD>  
	|	</TR>
	|";
	
	сШапка	= сШапка + "
	|</TBODY>
	|</TABLE>"; 
	
	сСтили		= ПолучитьСтилиCSSМеню();
	
	//СтрТекстHTMLЗадачи = сЗаголовок1+сСтили+сШапка+сТело2; 
	ТекстHTML = сЗаголовок1+сСтили+сШапка; 
	
	Возврат ТекстHTML;
	
КонецФункции

Функция ПолучитьСтилиCSSМеню()
	
	//ДвоичныеДанныеКартинки = БиблиотекаКартинок.CRM_Минус.ПолучитьДвоичныеДанные();
	//Base64ДанныеКартинки = Base64Строка(ДвоичныеДанныеКартинки);
	//КартинкаМинус = "data:image/" + БиблиотекаКартинок.CRM_Минус.Формат() + ";base64," + Base64ДанныеКартинки;
	//
	//ДвоичныеДанныеКартинки = БиблиотекаКартинок.CRM_Плюс.ПолучитьДвоичныеДанные();
	//Base64ДанныеКартинки = Base64Строка(ДвоичныеДанныеКартинки);
	//КартинкаПлюс = "data:image/" + БиблиотекаКартинок.CRM_Плюс.Формат() + ";base64," + Base64ДанныеКартинки;
	
	сСтили		= "
	|<STYLE>
	|BODY, TABLE {
	|	FONT-SIZE: 9.5pt; 
	|	FONT-FAMILY: Helvetica, Geneva, Arial, sans-serif;
	|}
	|a:link {
	|	COLOR: #3366FF;
	|	text-decoration: none;
	|}
	|a:visited {
	|	COLOR: #3366FF;
	|	text-decoration: none;
	|}
	|td.title {
	|	vertical-align: top;
	|}
	|.title_header {
	|	FONT-SIZE: 9.5pt; 
	|	FONT-WEIGHT: normal; 
	|	COLOR: #5D5D5D;
	|}
	|.title_header_1 {
	|	FONT-SIZE: 9.5pt; 
	|	FONT-WEIGHT: bolder; 
	|	COLOR: #5D5D5D;
	|}
	|.title_text {
	|	FONT-SIZE: 9.5pt; 
	|	FONT-WEIGHT: bolder; 
	|	COLOR: #000000; 
	|}
	|td.title_theme {
	|	PADDING-TOP: 5px;
	|	PADDING-BOTTOM: 5px; 
	|	PADDING-LEFT: 0px; 
	|	PADDING-RIGHT: 0px;
	|	BORDER-TOP: #c9c9c9 1px solid;
	|	BORDER-BOTTOM: #c9c9c9 1px solid;
	|}	
	|td.title_theme_alert {
	|	PADDING-TOP: 3px;
	|	PADDING-BOTTOM: 0px; 
	|	PADDING-LEFT: 15px; 
	|	PADDING-RIGHT: 0px;
	|	BORDER-TOP: #c9c9c9 1px solid;
	|	BORDER-BOTTOM: #c9c9c9 1px solid;
	|}	
	|span.title_theme_txt_1 {
	|	FONT-SIZE: 11pt; 
	|	FONT-WEIGHT: bolder; 
	|	COLOR: #000000; 
	|}	
	|span.title_theme_txt_2 {
	|	FONT-SIZE: 9.5pt; 
	|	FONT-WEIGHT: normal; 
	|	COLOR: #5D5D5D; 
	|}	
	|a.title_theme_txt_2:link, a.title_theme_txt_2:visited {
	|	FONT-SIZE: 9.5pt; 
	|	FONT-WEIGHT: normal; 
	|	COLOR: #3366FF; 
	|}	
	|.file_list {
	|	margin-left: 15px;}	
	|td.icon {
	|	PADDING-TOP: 7px; 
	|	PADDING-BOTTOM: 7px; 
	|	PADDING-LEFT: 0px; 
	|	PADDING-RIGHT: 15px
	|}
	|td.menu_header {
	|	PADDING-TOP: 0px; 
	|	PADDING-BOTTOM: 0px; 
	|	PADDING-LEFT: 0px; 
	|	PADDING-RIGHT: 15px;
	|	BORDER-TOP: #c9c9c9 1px solid;
	|}
	|td.menu_header_last {
	|	PADDING-TOP: 0px; 
	|	PADDING-BOTTOM: 0px; 
	|	PADDING-LEFT: 0px; 
	|	PADDING-RIGHT: 15px;
	|	BORDER-TOP: #c9c9c9 1px solid;
	|	BORDER-BOTTOM: #c9c9c9 1px solid;
	|}
	|td.menu_text {
	|	PADDING-TOP: 0px; 
	|	PADDING-BOTTOM: 5px; 
	|	PADDING-LEFT: 0px; 
	|	PADDING-RIGHT: 15px;
	|}
	|span.menu_header_txt_1 {
	|	FONT-SIZE: 10pt; 
	|	FONT-WEIGHT: bolder; 
	|	COLOR: #000000; 
	|}
	|span.menu_header_txt_2 {
	|	FONT-SIZE: 9pt; 
	|	FONT-WEIGHT: normal; 
	|	COLOR: #5D5D5D;
	|}
	|a.menu_header_txt_1, a.menu_header_txt_1:visited {
	|	COLOR: #000000;
	|}	
	|a.menu_header_txt_2, a.menu_header_txt_2:visited {
	|	COLOR: #5D5D5D;
	|}

	|td.file_list {
	|	PADDING-TOP: 0px; 
	|	PADDING-BOTTOM: 5px; 
	|	PADDING-LEFT: 0px; 
	|	PADDING-RIGHT: 15px;
	|}
	|</STYLE>
	|
	|<STYLE type=text/css>
	|
	|.CommentContainer {
	|	padding: 0;
	|	margin: 0;
	|}
	|
	|.CommentContainer li {
	|	list-style-type: none;
	|}
	|
	|.Node {
	|	background-image : url('');
	|	background-position : top left;
	|	background-repeat : repeat-y;
	|	zoom: 1;
	|}
	|
	|.IsRoot {
	|	margin-left: 0;
	|}
	|.ExpandOpen .Expand {
	//|	background-image: url('"+КартинкаМинус+"');
	|}
	|
	|.ExpandClosed .Expand {
	//|	background-image: url('"+КартинкаПлюс+"');
	|	background-repeat : no-repeat;
	|}
	|
	|.ExpandLeaf .Expand {
	|	background-image: url('');
	|}
	|
	|.Content {
	|min-height: 18px;
	//|margin-left:18px;
	|}
	|
	|* html .Content {
	|height: 18px;
	|}
	|
	|.Expand {
	|	width: 18px;
	|	height: 18px;
	|	float: left;
	//|	FONT-SIZE: 9.5pt;
	|	FONT-SIZE: 10.5pt;
	|	FONT-WEIGHT: bolder; 
	|}
	|
	|.ExpandOpen .CommentContainer {
	|   display: block;
	|}
	|
	|.ExpandClosed .CommentContainer {
	|   display: none;
	|}
	|
	|.ExpandOpen .Expand, .ExpandClosed .Expand {
	|   cursor: pointer;
	|}
	|
	|.ExpandLeaf .Expand {
	|	cursor: auto;
	|}
	|
	|</STYLE>";
	
	Возврат сСтили;

КонецФункции

Функция ПолучитьТекстHTMLДляСворачиваемогоТекста(ТекстЗаголовка, Текст, Свернута = Ложь, Вложенный = Ложь, ЕстьОтступ = Ложь) Экспорт
	
	idName = Строка(Новый УникальныйИдентификатор());
	
	МассивСтрок = РазложитьСтрокуВМассивПодстрок(Текст,Символы.ПС);
	
	ТекстВставки = ПолучитьТекстДляВставкиHTML(МассивСтрок);
	
	Если Вложенный Тогда
		СворачиваемыйТест = "
		|"+ ?(Свернута, "<LI class=""Node ExpandClosed"""+?(ЕстьОтступ,"style=""padding-left: 15px;""","")+">", "<LI class=""Node ExpandOpen"""+?(ЕстьОтступ,"style=""padding-left: 15px;""","")+">") + "
		|	<DIV onclick=""showHide('"+idName+"_sv', '"+idName+"')"" id="+idName+" class=Expand>"+?(Свернута,"+","-")+"</DIV>
		|	<DIV class=Content>
		//|		<P>
		|			<span class=""title_header_1"">
		|				"+ ТекстЗаголовка +"
		|			</span>
		//|		</P>
		|	</DIV>
		|	<UL class=CommentContainer id="+idName+"_sv style='display:"+ ?(Свернута,"none","block")+";'>
		|		<LI class=""Node ExpandLeaf IsLast"">
		|			<DIV class=Expand>
		|			</DIV>
		|			<DIV class=Content>
		|				"+ ТекстВставки +"
		|			</DIV>
		|		</LI>
		|	</UL>
		|</LI>";
	Иначе
		СворачиваемыйТест = "
		|<DIV  class=Content style='border: 1px solid black;'>
		|	<UL class=CommentContainer>
		|		"+ ?(Свернута, "<LI class=""Node ExpandClosed"""+?(ЕстьОтступ,"style=""padding-left: 15px;""","")+">", "<LI class=""Node ExpandOpen"""+?(ЕстьОтступ,"style=""padding-left: 15px;""","")+">") + "
		|			<DIV onclick=""showHide('"+idName+"_sv', '"+idName+"')"" id="+idName+" class=Expand>"+?(Свернута,"+","-")+"</DIV>
		|			<DIV class=Content>
		//|				<P>
		|					<span class=""title_header_1"">
		|						"+ ТекстЗаголовка +"
		|					</span>
		//|				</P>
		|			</DIV>
		|			<UL class=CommentContainer id="+idName+"_sv style='display:"+ ?(Свернута,"none","block")+";'>
		|				<LI class=""Node ExpandLeaf IsLast"">
		|					<DIV class=Expand>
		|					</DIV>
		|					<DIV class=Content>
		|						"+ ТекстВставки +"
		|					</DIV>
		|				</LI>
		|			</UL>
		|		</LI>
		|	</UL>
		|</DIV>";
	КонецЕсли;
	
	Возврат СворачиваемыйТест;
	
КонецФункции

Функция ПолучитьТекстДляВставкиHTML(Массив)
	Текст = ""; 
	Для Каждого СтрокаМассива Из Массив Цикл
		Текст = Текст+СтрокаМассива + "<br>";
	КонецЦикла;
	
	Возврат Текст;
КонецФункции

