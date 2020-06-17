# language: ru

Функционал: Работа плагина выгрузки конфигурации в формат EDT
    Как Пользователь
    Я хочу выполнять автоматическую синхронизацию конфигурации из хранилища в формат EDT
    Чтобы не использовать ГитКонвертер

Контекст: Тестовый контекст edtExport
    Когда Я очищаю параметры команды "gitsync" в контексте
    И Я устанавливаю рабочей каталог во временный каталог
    И Я создаю новый объект ГитРепозиторий
    И Я устанавливаю путь выполнения команды "gitsync" к текущей библиотеке
    И Я устанавливаю текущие плагины
    И Я создаю временный каталог и сохраняю его в переменной "КаталогХранилища1С"
    И Я создаю временный каталог и сохраняю его в переменной "РабочееОкружениеEDT"
    И я скопировал каталог тестового хранилища конфигурации в каталог из переменной "КаталогХранилища1С"
    И Я создаю временный каталог и сохраняю его в переменной "ПутьКаталогаИсходников"
    И Я инициализирую репозиторий в каталоге из переменной "ПутьКаталогаИсходников"
    И Я создаю тестовой файл AUTHORS 
    И Я записываю "0" в файл VERSION
    И Я создаю временный каталог и сохраняю его в переменной "ВременнаяДиректория"
    И Я добавляю параметр "--tempdir" для команды "gitsync" из переменной "ВременнаяДиректория"
    И Я добавляю параметр "-v" для команды "gitsync"
    И Я добавляю параметр "sync" для команды "gitsync"
    И Я добавляю параметр "-P test" для команды "gitsync"
    И Я выключаю все плагины
    И Я включаю плагин "edtExport"
    И Я включаю плагин "edtExport"

Сценарий: Cинхронизация с использованием edtExport
    Допустим Я добавляю позиционный параметр для команды "gitsync" из переменной "КаталогХранилища1С"
    И Я добавляю позиционный параметр для команды "gitsync" из переменной "ПутьКаталогаИсходников"
    Когда Я выполняю команду "gitsync"
    Тогда Вывод команды "gitsync" содержит "ИНФОРМАЦИЯ - Завершена синхронизации с git"
    И Вывод команды "gitsync" не содержит "Внешнее исключение"
    И Код возврата команды "gitsync" равен 0

Сценарий: Cинхронизация хранилища расширения с использованием edtExport без указания базового проекта
    Допустим Я скопировал каталог тестового хранилища конфигурации расширения в каталог из переменной "КаталогХранилища1С"
    И я скопировал каталог рабочего окружения EDT в каталог из переменной "РабочееОкружениеEDT"
    И Я добавляю параметр "-e test" для команды "gitsync"
    И Я добавляю позиционный параметр для команды "gitsync" из переменной "КаталогХранилища1С"
    И Я добавляю позиционный параметр для команды "gitsync" из переменной "ПутьКаталогаИсходников"
    Когда Я выполняю команду "gitsync"
    Тогда Вывод команды "gitsync" содержит "ИНФОРМАЦИЯ - Завершена синхронизации с git"
    И Вывод команды "gitsync" не содержит "Внешнее исключение"
    И Код возврата команды "gitsync" равен 0

Сценарий: Cинхронизация хранилища расширения с использованием edtExport c указанием базового проекта
    Допустим Я скопировал каталог тестового хранилища конфигурации расширения в каталог из переменной "КаталогХранилища1С"
    И я скопировал каталог рабочего окружения EDT в каталог из переменной "РабочееОкружениеEDT"
    И Я добавляю параметр "-e test" для команды "gitsync"
    И Я добавляю параметр "-W" для команды "gitsync" из переменной "РабочееОкружениеEDT"
    И Я добавляю параметр "-B edtExport" для команды "gitsync"
    И Я добавляю позиционный параметр для команды "gitsync" из переменной "КаталогХранилища1С"
    И Я добавляю позиционный параметр для команды "gitsync" из переменной "ПутьКаталогаИсходников"
    Когда Я выполняю команду "gitsync"
    Тогда Вывод команды "gitsync" содержит "ИНФОРМАЦИЯ - Завершена синхронизации с git"
    И Вывод команды "gitsync" не содержит "Внешнее исключение"
    И Код возврата команды "gitsync" равен 0
