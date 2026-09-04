# Publication Flows Menu

## Purpose

The flows menu combines the static navigation structure of the Habr web client with dynamic API content. The endpoint data populates nested panels with popular technologies and topics, posts, authors, companies, events, and promotional blocks.

This document describes behavior verified on September 4, 2026, against Habr web client version `2.346.1`. The structure and flow catalog are an internal website contract and may change without a versioned public announcement.

## Endpoint

```http
GET https://habr.com/kek/v2/flows/menu?fl=en%2Cru&hl=ru
```

### Request parameters

| Parameter | Purpose |
|---|---|
| `fl` | Publication languages included in dynamic collections. Values are comma-separated, for example `en,ru` |
| `hl` | Language of the interface and localized response content, for example `ru` or `en` |

`hl` affects hub names, topic names, and other content inside the collections. Flow aliases remain the same across interface languages.

## Response structure

The response contains three top-level fields:

```text
whatsNew
flows
events
```

### `whatsNew`

Content for the “What’s new” section. Depending on the current configuration, it may include:

- new authors;
- links to website changes and documents;
- social networks;
- topic channels;
- Habr blogs and activities;
- partner activities;
- an advertising block.

Each subsection contains an `order` field that determines its position within the corresponding panel.

### `flows`

An object whose keys are flow aliases and whose values contain the dynamic content of their panels. A typical entry has these subsections:

```text
technologies
topics
topPosts
topAuthors
topCompanies
banner
```

Each subsection contains `order`; list subsections also contain `items`.

Abbreviated example:

```json
{
  "flows": {
    "backend": {
      "technologies": {
        "order": 1,
        "items": [
          {
            "alias": "python",
            "title": "Python",
            "imageUrl": "//habrastorage.org/..."
          }
        ]
      },
      "topics": {
        "order": 2,
        "items": []
      },
      "topPosts": {
        "order": 3,
        "items": []
      },
      "topAuthors": {
        "order": 4,
        "items": []
      },
      "topCompanies": {
        "order": 5,
        "items": []
      },
      "banner": {
        "order": 6
      }
    }
  }
}
```

The order of keys inside `flows` does not determine navigation order. The web client uses its own ordered list.

### `events`

Events displayed in the menu. The client also considers the presence of events when deciding whether nested content is available.

## Flow catalog

The web client uses the following ordered catalog:

| Alias | Russian label | i18n key |
|---|---|---|
| `backend` | Бэкенд | `NAV_FLOW_BACKEND` |
| `frontend` | Фронтенд | `NAV_FLOW_FRONTEND` |
| `mobile_development` | Мобильная разработка | `NAV_FLOW_MOBILE_DEVELOPMENT` |
| `gamedev` | Геймдев | `NAV_FLOW_GAMEDEV` |
| `quality_assurance` | Тестирование | `NAV_FLOW_QUALITY_ASSURANCE` |
| `ai_and_ml` | AI и ML | `NAV_FLOW_AI_AND_ML` |
| `industrial_engineering` | Промышленная инженерия | `NAV_FLOW_INDUSTRIAL_ENGINEERING` |
| `admin` | Администрирование | `NAV_FLOW_ADMIN` |
| `information_security` | Информационная безопасность | `NAV_FLOW_INFORMATION_SECURITY` |
| `analytics` | Системный и бизнес-анализ | `NAV_FLOW_ANALYTICS` |
| `support` | Техническая поддержка | `NAV_FLOW_SUPPORT` |
| `management` | Менеджмент | `NAV_FLOW_MANAGEMENT` |
| `top_management` | Топ-менеджмент | `NAV_FLOW_TOP_MANAGEMENT` |
| `human_resources` | HR | `NAV_FLOW_HUMAN_RESOURCES` |
| `design` | Дизайн | `NAV_FLOW_DESIGN` |
| `marketing` | Маркетинг и контент | `NAV_FLOW_MARKETING` |
| `hardware_and_gadgets` | Железо и гаджеты | `NAV_FLOW_HARDWARE_AND_GADGETS` |
| `diy` | DIY | `NAV_FLOW_DIY` |
| `popsci` | Научпоп | `NAV_FLOW_POPSCI` |
| `healthcare` | Здоровье | `NAV_FLOW_HEALTHCARE` |

The “All flows” item is created separately with the `all` alias, the general publications route, and the `NAV_FLOWS_ALL` i18n key.

## Grouping

The web client defines the groups and their members statically.

### Development and engineering

Heading key: `NAV_DEVELOP_SECTION`.

```text
backend
frontend
mobile_development
gamedev
quality_assurance
ai_and_ml
industrial_engineering
```

### Infrastructure and data

Heading key: `NAV_INFRASTRUCTURE_SECTION`.

```text
admin
information_security
analytics
support
```

### Management

Heading key: `NAV_MANAGEMENT_SECTION`.

```text
management
top_management
human_resources
```

### Creative and promotion

Heading key: `NAV_CREATIVE_SECTION`.

```text
design
marketing
```

### Science and life

Heading key: `NAV_SCIENCE_SECTION`.

```text
hardware_and_gadgets
diy
popsci
healthcare
```

## Menu item construction

For each alias in the static catalog, the web client creates a model equivalent to:

```js
{
  alias,
  title: `NAV_FLOW_${alias.toUpperCase()}`,
  route: {
    name: 'FLOW_PAGE',
    params: { flowName: alias },
  },
  hasMenuContent: hasEvents || Boolean(response.flows?.[alias]),
}
```

The title is derived from the i18n key and resolved through the active language dictionary. For the Russian interface, the client loads the Russian dictionary containing `NAV_FLOW_*`, `NAV_*_SECTION`, and `NAV_FLOWS_ALL` values.

## Loading and display sequence

1. The web client determines the interface language and loads the corresponding i18n dictionary.
2. When the menu opens, the client requests `flows/menu` if the data is not already in application state and no request is currently running.
3. The response is stored in the client store.
4. The left navigation is built from the static catalog and static groups.
5. Item and group labels are resolved through i18n.
6. Data from `flows.<alias>` populates the nested panel for the selected flow.
7. The `order` fields control subsection placement inside the dynamic panel.
8. Reopening the menu reuses data already loaded during the current application lifecycle.

Opening the menu also sends the `flows_menu_open` client analytics event after preparing the UUID and feature flags.

## Responsibility boundaries

| Source | Responsibility |
|---|---|
| Static web client code | Flow set, order, grouping, routes, and rules for nested panel availability |
| Web client i18n dictionary | Labels for flows, groups, and utility menu items |
| `GET /kek/v2/flows/menu` | Current dynamic content of nested panels |
