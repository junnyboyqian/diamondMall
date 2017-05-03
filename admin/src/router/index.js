/*
* @Author: f
* @Date:   2017-01-03 15:44:46
* @Last Modified by:   gaofan
* @Last Modified time: 2017-04-10 15:11:51
*/

import Vue from 'vue'
import Router from 'vue-router'

const index = resolve => require(['../views/index'], resolve)
const step1 = resolve => require(['../views/step1'], resolve)
const step2 = resolve => require(['../views/step2'], resolve)
const step3 = resolve => require(['../views/step3'], resolve)
const step4 = resolve => require(['../views/step4'], resolve)
const step5 = resolve => require(['../views/step5'], resolve)
const step6 = resolve => require(['../views/step6'], resolve)

Vue.use(Router)
const router = new Router({
    mode: 'history',
    base: __dirname,
    routes: [
        {
            path: '/',
            component: index
        },
        {
            path: '/step1',
            component: step1
        },
        {
            path: '/step2',
            component: step2
        },
        {
            path: '/step2',
            component: step2
        },
        {
            path: '/step3',
            component: step3
        },
        {
            path: '/step4',
            component: step4
        },
        {
            path: '/step5',
            component: step5
        },
        {
            path: '/step6',
            component: step6
        }
    ]
})

router.beforeEach((to, from, next) => {
    next()
})

export default router
