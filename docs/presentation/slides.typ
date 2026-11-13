#let ink = rgb("18252E")
#let muted = rgb("687780")
#let blue = rgb("2260E5")
#let pale = rgb("EEF2F6")
#set page(width: 960pt, height: 540pt, margin: (x: 52pt, y: 38pt), fill: rgb("FAFBFC"), footer: context align(right, text(size: 12pt, fill: muted, counter(page).display("01"))))
#set text(font: "Lato", size: 20pt, fill: ink, lang: "ru")
#set par(leading: 0.25em, spacing: 0pt)
#let title(body) = [#text(size: 36pt, weight: "bold", body) #v(30pt)]
#let small(body) = text(size: 12pt, fill: muted, body)
#let item(head, body) = [#text(weight: "bold", head) #v(7pt) #text(fill: muted, body)]
#let mock(head, body, height: 180pt) = block(width: 100%, height: height, fill: pale, inset: 22pt)[
  #align(center + horizon)[#text(fill: muted, head) #v(12pt) #small(body)]
]

#small[СОРЕВНОВАНИЯ ПО АВТОНОМНОЙ РОБОТОТЕХНИКЕ · 2026]
#v(43pt)
#title[Виртуальный курьер]
#text(fill: muted)[Навигация и доставка грузов\ в неизвестном лабиринте]
#v(32pt)
#text(fill: muted)[Задача: найти активные станции, забрать грузы\ и доставить их на старт за ограниченное время.]
#place(bottom + right, dy: -36pt)[
  #align(right)[
    #text(weight: "bold")[Команда «Вкатуны»]
    #v(14pt)
    Тарасов Иван — навигация и исследование
    #v(10pt)
    Филиппов Никита — парковка и управление доставкой
  ]
]

#pagebreak()
#title[Что взяли готовое и что сделали сами]
#grid(columns: (1fr, 1fr), gutter: 48pt,
  [
    #text(weight: "bold", fill: blue)[Взяли готовое]
    #v(22pt)
    #item[Среда организаторов][Симулятор Webots, робот и судья]
    #v(20pt)
    #item[SLAM Toolbox и Nav2][Построение карты и движение по маршруту]
    #v(20pt)
    #item[OpenCV / ArUco][Распознавание маркеров]
  ],
  [
    #text(weight: "bold", fill: blue)[Сделали сами]
    #v(22pt)
    #item[Исследование лабиринта][Запоминаем клетки и проходы, выбираем следующую цель]
    #v(20pt)
    #item[Работа со станциями][Находим станции, проверяем наличие груза, паркуемся]
    #v(20pt)
    #item[Управление доставкой][Переключаем робота между поиском, загрузкой и доставкой]
  ],
)

#pagebreak()
#title[Исследование лабиринта]
#grid(columns: (290pt, 1fr), gutter: 34pt,
  [
    Делим карту на клетки и выбираем, какую из них проверить следующей.
    #v(19pt)
    #text(fill: muted)[Запоминаем, где между клетками есть проход, где стена, а где ещё нужно проверить.]
    #v(19pt)
    #text(fill: muted)[Nav2 строит маршрут до выбранной точки и управляет движением.]
  ],
  [#image("screenshots/navigation-route.svg", width: 100%, height: 350pt, fit: "contain")],
)

#pagebreak()
#title[Правила выбора цели]
#table(
  columns: (1fr, 1.25fr),
  inset: (x: 0pt, y: 9pt),
  column-gutter: 36pt,
  stroke: none,
  table.header(text(weight: "bold", fill: blue)[Какая проблема], text(weight: "bold", fill: blue)[Как решили]),
  [Начали с универсального алгоритма исследования, но робот отвлекался на случайные пробелы на карте.],
  [Использовали известную клеточную структуру лабиринта.],
  [Близкая по координатам цель может требовать длинного объезда стен.],
  [Сравниваем длину реальных маршрутов с обходом стен.],
  [Перед поездкой к новой цели робот тратит время на разворот.],
  [Предпочитаем цели, к которым можно поехать с меньшим разворотом.],
  [Робот исследует внутренние клетки, хотя станции находятся у внешних стен.],
  [Чаще выбираем цели у внешних стен.],
  [Робот тормозит в каждой клетке коридора.],
  [Переносим цель дальше по открытому коридору.],
  [Робот слишком часто меняет цель и направление движения.],
  [Сохраняем текущую цель, пока другая не станет заметно выгоднее.],
)

#pagebreak()
#title[Загрузка и парковка]
#grid(columns: (1fr, 1fr), gutter: 40pt,
  [
    #text(weight: "bold")[На станции загрузки]
    #v(14pt)
    #text(fill: muted)[По маркеру узнаём станцию, по лампе проверяем, есть ли на ней груз. Приезжаем и останавливаемся для загрузки.]
    #v(23pt)
    #image("screenshots/station-cv.png", width: 100%, height: 210pt, fit: "contain")
  ],
  [
    #text(weight: "bold")[В зоне выгрузки]
    #v(14pt)
    #text(fill: muted)[Выравниваемся по маркеру и подъезжаем. Затем разворачиваемся, сдаём назад и наклоняем лоток.]
    #v(23pt)
    #image("screenshots/unloading.png", width: 100%, height: 210pt, fit: "contain")
  ],
)

#pagebreak()
#title[Что исправили при парковке]
#table(
  columns: (1fr, 1fr),
  inset: (x: 0pt, y: 20pt),
  column-gutter: 40pt,
  stroke: none,
  table.header(text(weight: "bold", fill: blue)[Какая проблема], text(weight: "bold", fill: blue)[Как решили]),
  [Робот видел маркер базы издалека и ехал к нему напрямую, хотя на пути была стена.],
  [Сначала возвращаемся на базу по маршруту Nav2. Только потом паркуемся по камере.],
  [У самой стены маркер не помещался в кадр. Робот вращался, но не мог его распознать.],
  [Отъезжаем назад, если сзади свободно, и снова ищем маркер.],
)

#pagebreak()
#title[Управление доставкой]
#image("delivery-states.svg", width: 100%)

#pagebreak()
#title[Известные проблемы]
#set list(spacing: 13pt, indent: 15pt, body-indent: 8pt)
- Робот может проехать мимо станции, не увидеть маркер — например, если его заслонила паллета, — и больше к ней не вернуться.
- Когда цели исследования закончились, робот ждал возврата по времени, хотя уже вёз грузы.
- В одном из заездов при выгрузке один из трёх грузов выпал за пределы зоны.
- На сервере с 4 vCPU робот иногда зависал или набирал меньше баллов, чем на ноутбуке на той же карте. Возможно, ему не хватало вычислительных ресурсов; точную причину мы не установили.

#pagebreak()
#title[Спасибо за внимание]
#text(weight: "bold")[Команда «Вкатуны»]
#v(28pt)
#grid(columns: (1fr, 1fr), gutter: 40pt,
  align(center)[
    #box(width: 200pt, height: 200pt, radius: 100pt, clip: true)[#image("screenshots/vania-photo.png", width: 200pt, height: 200pt, fit: "cover")]
    #v(18pt)
    Тарасов Иван
  ],
  align(center)[
    #box(width: 200pt, height: 200pt, radius: 100pt, clip: true)[#image("screenshots/nikita-photo.jpg", width: 200pt, height: 200pt, fit: "cover")]
    #v(18pt)
    Филиппов Никита
  ],
)
