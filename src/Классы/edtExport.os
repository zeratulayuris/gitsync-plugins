#Использовать logos
#Использовать tempfiles
#Использовать fs

Перем ВерсияПлагина;
Перем Лог;
Перем Обработчик;
Перем КомандыПлагина;

Перем ИмяПроекта;
Перем РабочееПространство;
Перем ИмяРасширения;
Перем ИмяБазовогоПроекта;

#Область Интерфейс_плагина

// Возвращает версию плагина
//
//  Возвращаемое значение:
//   Строка - текущая версия плагина
//
Функция Версия() Экспорт
	Возврат ВерсияПлагина;
КонецФункции

// Возвращает приоритет выполнения плагина
//
//  Возвращаемое значение:
//   Число - приоритет выполнения плагина
//
Функция Приоритет() Экспорт
	Возврат 0;
КонецФункции

// Возвращает описание плагина
//
//  Возвращаемое значение:
//   Строка - описание функциональности плагина
//
Функция Описание() Экспорт
	Возврат "Плагин добавляет возможность выгрузки в формате EDT." 
	 + " Важно: Для работы плагина необходимы установленные EDT и Ring";
КонецФункции

// Возвращает подробную справку к плагину 
//
//  Возвращаемое значение:
//   Строка - подробная справка для плагина
//
Функция Справка() Экспорт
	Возврат "Справка плагина";
КонецФункции

// Возвращает имя плагина
//
//  Возвращаемое значение:
//   Строка - имя плагина при подключении
//
Функция Имя() Экспорт
	Возврат "edtExport";
КонецФункции 

// Возвращает имя лога плагина
//
//  Возвращаемое значение:
//   Строка - имя лога плагина
//
Функция ИмяЛога() Экспорт
	Возврат "oscript.lib.gitsync.plugins.edtExport";
КонецФункции

#КонецОбласти

#Область Подписки_на_события

Процедура ПриАктивизации(СтандартныйОбработчик) Экспорт

	Обработчик = СтандартныйОбработчик;

КонецПроцедуры

// BSLLS:UnusedParameters-off
Процедура ПередНачаломВыполнения(ПутьКХранилищу, КаталогРабочейКопии) Экспорт
// BSLLS:UnusedParameters-on

	ИмяРасширения = Обработчик.ПолучитьИмяРасширения();

КонецПроцедуры

Процедура ПриРегистрацииКомандыПриложения(ИмяКоманды, КлассРеализации) Экспорт

	Лог.Отладка("Ищу команду <%1> в списке поддерживаемых", ИмяКоманды);
	Если КомандыПлагина.Найти(ИмяКоманды) = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Лог.Отладка("Устанавливаю дополнительные параметры для команды %1", ИмяКоманды);
	
	КлассРеализации.Опция("P project-name", "", "[*edtExport] Имя проекта")
						.ТСтрока()
						.ВОкружении("GITSYNC_PROJECT_NAME");

	КлассРеализации.Опция("W workspace-location", "", "[*edtExport] расположение рабочей области")
						.ТСтрока()
						.ВОкружении("GITSYNC_WORKSPACE_LOCATION");

	КлассРеализации.Опция(
		"B base-project-name", 
		"", 
		"[*edtExport] имя базового проекта в рабочей области (для расширений))")
			.ТСтрока()
			.ВОкружении("GITSYNC_BASE_PROJECT_NAME");

КонецПроцедуры

Процедура ПриПолученииПараметров(ПараметрыКоманды) Экспорт
	
	ИмяПроекта          = ПараметрыКоманды.Параметр("project-name");
	РабочееПространство = ПараметрыКоманды.Параметр("workspace-location");
	ИмяБазовогоПроекта  = ПараметрыКоманды.Параметр("base-project-name");

	Если Не ПустаяСтрока(ИмяРасширения) 
		И Не ПустаяСтрока(ИмяБазовогоПроекта)
		И ПустаяСтрока(РабочееПространство) Тогда
	
	 	ВызватьИсключение "При конвертации расширений с указанием базового проекта, 
		 |параметр workspace-location обязателен";

	КонецЕсли;

	Если ПустаяСтрока(ИмяПроекта) Тогда
		ВызватьИсключение "Не заполнено имя проекта";
	КонецЕсли;

КонецПроцедуры

// BSLLS:UnusedParameters-off
Процедура ПередПеремещениемВКаталогРабочейКопии(
		Конфигуратор, 
		КаталогРабочейКопии, 
		КаталогВыгрузки, 
		ПутьКХранилищу, 
		НомерВерсии) Экспорт
// BSLLS:UnusedParameters-on

	Лог.Отладка("Начинаю выгрузку EDT");
	Лог.Отладка("Имя проекта: %1", ИмяПроекта);

	ВременноеРабочееПространство = ВременныеФайлы.СоздатьКаталог();
	Если Не ПустаяСтрока(РабочееПространство) Тогда
		ФС.КопироватьСодержимоеКаталога(РабочееПространство, ВременноеРабочееПространство);
	КонецЕсли;

	Лог.Отладка("Рабочее пространство EDT: %1", ВременноеРабочееПространство);
	
	КаталогПроекта = ОбъединитьПути(ВременноеРабочееПространство, ИмяПроекта);

	Лог.Отладка("Каталог проекта EDT: %1", КаталогПроекта);
	ФС.ОбеспечитьПустойКаталог(КаталогПроекта);

	Команда = Новый Команда;
	
	Параметры = Новый Массив();
	Параметры.Добавить(СтрШаблон("--configuration-files ""%1""", КаталогВыгрузки));
	Параметры.Добавить(СтрШаблон("--workspace-location ""%1""",  ВременноеРабочееПространство));
	Параметры.Добавить(СтрШаблон("--project ""%1""",             КаталогПроекта));
	
	Если Не ПустаяСтрока(ИмяРасширения) И Не ПустаяСтрока(ИмяБазовогоПроекта) Тогда
		Параметры.Добавить(СтрШаблон("--base-project-name ""%1""", ИмяБазовогоПроекта));
	КонецЕсли;

	Команда.УстановитьСтрокуЗапуска("ring edt workspace import");
	Команда.УстановитьКодировкуВывода(КодировкаТекста.ANSI);
	Команда.ДобавитьЛогВыводаКоманды("oscript.lib.gitsync.plugins.edtExport");
	Команда.ДобавитьПараметры(Параметры);
	Команда.УстановитьИсполнениеЧерезКомандыСистемы(Истина);
	Команда.ПоказыватьВыводНемедленно(Ложь);
	Команда.УстановитьПравильныйКодВозврата(0);
	КодВозврата = Команда.Исполнить();

	Лог.Отладка("Код возврата EDT: %1", КодВозврата);

	Лог.Отладка("Очищаю каталог выгрузки");
	УдалитьФайлы(КаталогВыгрузки, "*");

	Лог.Отладка("Копирую каталог проекта EDT в каталог выгрузки");
	ФС.КопироватьСодержимоеКаталога(КаталогПроекта, КаталогВыгрузки);

КонецПроцедуры

#КонецОбласти

Процедура Инициализация()

	ВерсияПлагина = "1.2.0";
	Лог = Логирование.ПолучитьЛог(ИмяЛога());
	КомандыПлагина = Новый Массив;
	КомандыПлагина.Добавить("sync");
	
	ИмяРасширения       = "";
	РабочееПространство = "";
	ИмяБазовогоПроекта  = "";

КонецПроцедуры

Инициализация();
