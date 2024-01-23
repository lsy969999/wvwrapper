import React from 'react'
import { useNavigate } from 'react-router-dom'

const PixiView = () => {
  const navigate = useNavigate()
  const backHandler = () => {
    navigate(-1)
  }
  return (
    <div>
      <nav>
        <button onClick={backHandler}>
            back
        </button>
      </nav>
    </div>
  )
}

export default PixiView