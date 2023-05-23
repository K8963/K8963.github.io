---
title: Vue日常使用
date: 2022-11-14 10:30:00
comments: false
author: 8963
tags:
  - vue
categories:
  - 前端
---

Vue日常使用

<!-- more -->


# 父组件数据联动子组件

父组件向子组件传递数据，当父组件数据修改时，子组件一并修改，使用watch

```typescript
// 子组件中
const props: any = defineProps({
	id: {
		type: Array,
		required: true
	},
  // 需要同步的数据
	eventData: {
		type: Array
	},
})

const eventTableData = ref<Event.Event[]>(props.eventData)
watch(
	() => props.eventData,
	() => {
		eventTableData.value = props.eventData
	},
	{ deep: true }
)
```



# 携带参数跳转

路由

```ts
{
	path: "workbench/:id",
	name: "workbench",
	component: () => import("@/views/home/workbench.vue"),
	meta: {
		title: "工作台"
	}
}
```

跳转

```ts
const gotoShow = (data: TimeLine.TimeLine) => {
	let routeData = router.resolve({
		path: "workbench" + "/" + data._id
	})
	window.open(routeData.href, "_self")
}
```

获取参数

```ts
import { useRoute } from "vue-router"
const route = useRoute()
const id: any = route.params.id
```

