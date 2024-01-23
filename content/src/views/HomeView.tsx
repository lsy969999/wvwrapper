import React from 'react'
import { Link } from 'react-router-dom'

const HomeView = () => {
  return (
    <div>
      HomeView
      <nav>
        <ul>
          <li>
            <Link to="/hello">go Hello</Link>
          </li>
          <li>
            <Link to="/pixi">go Pixi</Link>
          </li>
        </ul>
      </nav>
    </div>
  )
}

export default HomeView