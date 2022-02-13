import faker from 'faker';
import Person from './Person';

const App = (): JSX.Element => {
    const name = faker.name.findName();
    console.log(name);
    return <div>
        <Person personName={name} age ={30}/>
    </div>
};

export default App;
