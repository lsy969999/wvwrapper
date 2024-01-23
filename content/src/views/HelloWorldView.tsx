import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom';
import styled from 'styled-components';

const Title = styled.h1`
  font-size: 1.5em;
  text-align: center;
  color: BF4F74;
`
const Wrapper = styled.section`
  padding: 4em;
  background: papayawhip;
`

const Button = styled.button`
  background-color: blue;
`
const HelloWorldView = () => {
  const navigate = useNavigate()
  let [clickCnt, setClickCnt] = useState(0);

  const clickHandler = () => {
    setClickCnt(clickCnt + 1)
  }
  const backHandler = () => {
    navigate(-1)
  }
  return (
    <Wrapper>
      <Title>
        Hello World! {clickCnt}
        <Button onClick={clickHandler}>
          btn
        </Button>
        <button onClick={backHandler}>
          back
        </button>
      </Title>
    </Wrapper>
  )
}

export default HelloWorldView