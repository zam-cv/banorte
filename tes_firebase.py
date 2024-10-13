#Conexión con la base de datos de Firebase
from google.cloud import firestore
#Declarar la base de datos
db = firestore.Client(project='gcp-banorte-hackaton-team-5', database='hack-banorte')

doc_ref = db.collection(u'user_data').document(u'B0nDZBfLZrqkcT1eycX4')

#Función para obtener todos los datos de la base de datos
def get_specific_data(in_user_email: str):
    doc_ref = db.collection(u'user_data').stream()
    for doc in doc_ref:
        doc_dict = doc.to_dict()
        if doc_dict['email'] == in_user_email:
            doc_dict['id'] = doc.id
            return doc_dict

#Función para obtener todos los datos de la base de datos
def reference_data():
    data: dict = {}
    for doc in db.collection(u'user_data').stream():
        values = doc.to_dict()
        data[values['email']] = values
    return data

#Función para actualizar el streak de un usuario
def update_streak(in_user_email: str, in_streak: int):
    data=get_specific_data(in_user_email)
    doc_ref = db.collection(u'user_data').document(data['id'])
    doc_ref.update({'streak': in_streak})
    print(f'Document {doc_ref.id} updated successfully.')
    
#Función para calificar a un usuario
def grade_user(in_user_email: str):
    user_data = get_specific_data(in_user_email)
    if user_data['streak'] <= 3:
        return 'Conocimiento básico'
    elif user_data['streak'] <= 6:
        return 'Conocimiento medio'
    else:
        return 'Conocimiento avanzado'

#Función para obtener el contexto de un usuario 
def user_context(in_user_email: str) -> str:
    data = get_specific_data(in_user_email)
    user_context = "sin datos"
    try:
        conocimiento = grade_user(in_user_email)
        fecha = data['Birth_date'].date()    
        user_context = f"{data['name'] } {data['last_names']} y nació el {fecha} esta persona esta aprendiendo sobre educación financiera actualmente en el juego tiene {conocimiento}"
    except KeyError:
        print('KeyError')
    return user_context

###
# Test de las funciones
###
if __name__ == '__main__':

    print(grade_user('a01749675@tec.mx'))

    user = get_specific_data('a01749675@tec.mx')
    print(user)
    user_contextv = user_context('a01749675@tec.mx')

        
    print(user_contextv)

    update_streak('a01749675@tec.mx',0)

    user= get_specific_data('a01749675@tec.mx')

    print(user)
