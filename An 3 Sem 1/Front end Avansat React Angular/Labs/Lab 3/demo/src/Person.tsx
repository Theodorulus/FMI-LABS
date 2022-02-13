import React, {useState} from 'react'

interface PropsPerson {
    personName: string;
    age?: number;
}

interface Object {
    propOne: string;
    propTwo: number;
}

const Person = ({personName, age = 10} : PropsPerson) => {
    const [clicks, setClicks] = useState(0)
    const [object, setObject] = useState<Object | null>(null)
    const [value, setValue] = useState('alex')

    const handleClick = (event: React.MouseEvent<HTMLButtonElement, MouseEvent>) => {
        setClicks(clicks + 1);

    }

    const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
        setValue(e.target.value);
    }

    return <div>
            <section>
                {`Welcome back, ${personName}! `}
                {`Age: ${age}!`}
            </section>

            <aside>
                <h3>{`You clicked ${clicks} times`}</h3>
                <button onClick = {handleClick}>Click me!</button>
            </aside>

            <aside>
                <input value={value} onChange = {handleChange}/>
            </aside>

        </div>
};

export default Person;