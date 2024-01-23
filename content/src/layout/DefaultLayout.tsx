import React from 'react'
import { Outlet } from 'react-router-dom'

const DefaultLayout = () => {
  return (
    <div>
      <header>default Layout</header>
      <Outlet/>
    </div>
  )
}

export default DefaultLayout