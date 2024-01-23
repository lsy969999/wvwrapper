import { useNavigate } from 'react-router-dom'
import CanvasGameView from '../game/CanvasGameView'

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
      <CanvasGameView/>
    </div>
  )
}

export default PixiView