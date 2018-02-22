from pandevice import firewall
from pandevice import policies
from pandevice import objects

import json
import logging
import sys
import os

logging.basicConfig(level=8)

gd_finding = '''
[
  {
  "detail": {
    "schemaVersion": "2.0",
    "region": "us-west-2",
    "partition": "aws",
    "id": "9cb0da8eee22ffdb25dee0e56ddb8740",
    "arn": "arn:aws:guardduty:us-west-2:140651570565:detector/f4afdb9f43c68ca3fdc7eefa34ae392f/finding/9cb0da8eee22ffdb25dee0e56ddb8740",
    "type": "Recon:IAMUser/MaliciousIPCaller.Custom",
    "resource": {
      "resourceType": "AccessKey",
      "accessKeyDetails": {
        "accessKeyId": "ASIAIM",
        "userType": "Root",
        "userName": "Root"
      }
    },
    "service": {
      "serviceName": "guardduty",
      "detectorId": "f4afdb9f43c68ca3fdc7eefa34ae392f",
      "action": {
        "actionType": "AWS_API_CALL",
        "awsApiCallAction": {
          "api": "ListFunctions20150331",
          "serviceName": "lambda.amazonaws.com",
          "callerType": "Remote IP",
          "remoteIpDetails": {
            "ipAddressV4": "199.167.54.229",
            "organization": {
              "asn": "396421",
              "asnOrg": "PALO ALTO NETWORKS",
              "isp": "Palo Alto Networks",
              "org": "Palo Alto Networks"
            },
            "country": {
              "countryName": "United States"
            },
            "city": {
              "cityName": "Santa Clara"
            },
            "geoLocation": {
              "lat": 37.3486,
              "lon": -121.951
            }
          },
          "affectedResources": {}
        }
      },
      "resourceRole": "TARGET",
      "additionalInfo": {
        "threatListName": "vv-gd",
        "apiCalls": [
          {
            "name": "ListFunctions20150331",
            "count": 4,
            "firstSeen": 1519161279,
            "lastSeen": 1519161280
          }
        ]
      },
      "eventFirstSeen": "2018-02-20T21:14:39Z",
      "eventLastSeen": "2018-02-20T21:59:26Z",
      "archived": false,
      "count": 54
    },
    "severity": 5,
    "createdAt": "2018-02-20T21:28:08.517Z",
    "updatedAt": "2018-02-20T22:14:01.408Z",
    "title": "Reconnaissance API ListFunctions20150331 was invoked from an IP address on a custom threat list.",
    "description": "API ListFunctions20150331, commonly used in reconnaissance attacks, was invoked from an IP address 199.167.54.229 on the custom threat list vv-gd. Unauthorized actors perform such activity to gather information and discover resources like databases, S3 buckets etc., in order to further tailor the attack."
    }
  },
  {
    "detail": {
    "schemaVersion": "2.0",
    "region": "us-west-2",
    "partition": "aws",
    "id": "aab0a6dfa206ad5b35117774c12ef57f",
    "arn": "arn:aws:guardduty:us-west-2:140651570565:detector/f4afdb9f43c68ca3fdc7eefa34ae392f/finding/aab0a6dfa206ad5b35117774c12ef57f",
    "type": "Recon:EC2/PortProbeUnprotectedPort",
    "resource": {
      "resourceType": "Instance",
      "instanceDetails": {
        "instanceId": "i-0bd5f7a0d50b14bed",
        "instanceType": "t2.micro",
        "launchTime": "2018-01-31T19:23:05Z",
        "platform": null,
        "productCodes": [],
        "iamInstanceProfile": null,
        "networkInterfaces": [
          {
            "ipv6Addresses": [],
            "privateDnsName": "ip-172-31-45-169.us-west-2.compute.internal",
            "privateIpAddress": "172.31.45.169",
            "privateIpAddresses": [
              {
                "privateDnsName": "ip-172-31-45-169.us-west-2.compute.internal",
                "privateIpAddress": "172.31.45.169"
              }
            ],
            "subnetId": "subnet-7461ef11",
            "vpcId": "vpc-f205b397",
            "securityGroups": [
              {
                "groupName": "launch-wizard-1",
                "groupId": "sg-dc25e7a3"
              }
            ],
            "publicDnsName": "ec2-54-201-253-151.us-west-2.compute.amazonaws.com",
            "publicIp": "54.201.253.151"
          }
        ],
        "tags": [],
        "instanceState": "running",
        "availabilityZone": "us-west-2a",
        "imageId": "ami-f2d3638a",
        "imageDescription": "Amazon Linux AMI 2017.09.1.20180115 x86_64 HVM GP2"
      }
    },
    "service": {
      "serviceName": "guardduty",
      "detectorId": "f4afdb9f43c68ca3fdc7eefa34ae392f",
      "action": {
        "actionType": "PORT_PROBE",
        "portProbeAction": {
          "portProbeDetails": [
            {
              "localPortDetails": {
                "port": 22,
                "portName": "SSH"
              },
              "remoteIpDetails": {
                "ipAddressV4": "61.153.56.30",
                "organization": {
                  "asn": "4134",
                  "asnOrg": "No.31,Jin-rong Street",
                  "isp": "China Telecom",
                  "org": "China Telecom Quzhou"
                },
                "country": {
                  "countryName": "China"
                },
                "city": {
                  "cityName": "Quzhou"
                },
                "geoLocation": {
                  "lat": 28.9594,
                  "lon": 118.8686
                }
              }
            }
          ],
          "blocked": false
        }
      },
      "resourceRole": "TARGET",
      "additionalInfo": {
        "threatName": "Scanner",
        "threatListName": "ProofPoint"
      },
      "eventFirstSeen": "2018-01-31T19:31:14Z",
      "eventLastSeen": "2018-01-31T19:32:07Z",
      "archived": false,
      "count": 1
    },
    "severity": 2,
    "createdAt": "2018-01-31T19:43:55.917Z",
    "updatedAt": "2018-01-31T19:43:55.917Z",
    "title": "Unprotected port on EC2 instance i-0bd5f7a0d50b14bed is being probed.",
    "description": "EC2 instance has an unprotected port which is being probed by a known malicious host."
  }
  }
]
'''

def handle_gd_threat_intel(event, context):

    l_event = None
    ip_list = []
    print("Received event: " + json.dumps(event, indent=2))
    print("Event type: {}".format(type(event)))
    if isinstance(event, (list, tuple)):
        print("There are potentially multiple events")
        for _event in event:
            print("********** Dict: Event details: {}".format(_event))
            ip = process_threat_intel_data(_event)
            ip_list.append(ip)
        return ip_list
    else:
        print("There is only a single event to process in this finding. ")
        l_event = event
        print("Dict: Event details: {}".format(event))
        ip_address = process_threat_intel_data(l_event)
        return ip_address

def local_handle_gd_threat_intel(event):

    l_event = None
    ip_list = []
    print("Received event: " + json.dumps(event, indent=2))
    print("Event type: {}".format(type(event)))
    if isinstance(event, (list, tuple)):
        #l_event = event[0]
        #print("Extracted time from list: {}".format(l_event))
        print("There are potentially multiple events")
        for _event in event:
            print("*********** Dict: Event details: {}".format(_event))
            ip = process_threat_intel_data(_event)
            ip_list.append(ip)
        return ip_list
    else:
        l_event = event
        print("Dict: Event details: {}".format(event))
        process_threat_intel_data(l_event)

def process_threat_intel_data(event):
    """
    Process the threat finding to 
    take the appropriate action.
    
    :param event: 
    :return: 
    """

    print("GuardDuty Finding Event Details: {}".format(event))
    detail = event.get('detail')
    service = detail.get('service')
    print("Service details: {}".format(service))
    action = service.get('action')
    print("Action: {}".format(action))

    # Now need to demultiplex the action key-value pairs
    actionType = action.get('actionType')

    ip_address = None
    if actionType == "PORT_PROBE":
        ip_address = handle_port_probe_action(action)
    elif actionType == "AWS_API_CALL":
        ip_address = handle_aws_api_call_action(action)
    elif actionType == "DNS_REQUEST":
        print("DNS Request received. NO OP.")
    elif actionType == "NETWORK_CONNECTION":
        print("Not yet handling this.")

    return ip_address

def handle_gd_network_connection_action(data):
    """
    Process the NETWORK_CONNECTION action type
    from the guard duty finding.
    
    :param data: 
    :return: 
    """
    pass

def handle_aws_api_call_action(action):
    """
    Process the AWS_API_CALL action type from 
    the guard duty finding.
    
    :param data: 
    :return: 
    """
    apiCallAction = action.get("awsApiCallAction")
    print("apiCallAction: {}".format(apiCallAction))
    remoteIpDetails = apiCallAction.get("remoteIpDetails")
    print("remoteIpDetails: {}".format(remoteIpDetails))
    ipAddressV4 = remoteIpDetails.get('ipAddressV4')
    print("Guard Duty Flagged IP: {}".format(ipAddressV4))
    return ipAddressV4

def handle_port_probe_action(action):
    """
    Handle the PORT_PROBE action type from the 
    guard duty finding.
    :param data: 
    :return: 
    """
    portProbeAction = action.get("portProbeAction")
    print("Port Probe action: {}".format(portProbeAction))
    portProbeDetails = portProbeAction.get("portProbeDetails")
    remoteIpDetails = portProbeDetails[0].get("remoteIpDetails")
    ip_address = remoteIpDetails.get("ipAddressV4")
    print("Port probe Address originated from {}".format(ip_address))
    return ip_address

def handle_dns_request_action(data):
    """
    Handle the DNS_REQUEST action type from the 
    guard duty finding.
    
    :param data: 
    :return: 
    """
    pass

def register_ip_to_tag_map(device, ip_addresses, tag):
    """

    :param device:
    :param ip_addresses:
    :param tag:
    :return:
    """

    exc = None
    try:
        device.userid.register(ip_addresses, tag)
    except Exception, e:
            exc = get_exception()

    if exc:
        return (False, exc)
    else:
        return (True, exc)

def configure_fw_dag(ipAddressV4):

    print("Setting up a DAG to block IP: {}".format(ipAddressV4))


def create_address_group_object(**kwargs):
    """
    Create an Address object

    @return False or ```objects.AddressObject```
    """
    ad_object = objects.AddressGroup(
        name=kwargs['address_gp_name'],
        dynamic_value=kwargs['dynamic_value'],
        description=kwargs['description'],
        tag=kwargs['tag_name']
    )
    if ad_object.static_value or ad_object.dynamic_value:
        return ad_object
    else:
        return None

def get_all_address_group(device):
    """
    Retrieve all the tag to IP address mappings
    :param device:
    :return:
    """
    exc = None
    try:
        ret = objects.AddressGroup.refreshall(device)
    except Exception, e:
        print e
        exc = e

    if exc:
        return (False, exc)
    else:
        l = []
        for item in ret:
            l.append(item.name)
        return l, exc

def add_address_group(device, ag_object):
    """
    Create a new dynamic address group object on the
    PAN FW.
    """

    device.add(ag_object)

    ag_object.create()
    return True

def check_dag_exists(device, group_name):
    """
    Introspect the VM-Series FW and check if the 
    DAG exists
    :param device: 
    :param group_name: 
    :return: 
    """
    pass

def handle_dags(device, group_name, dag_match_filter):
    commit = True
    ag_object = create_address_group_object(address_gp_name=group_name,
                                            dynamic_value=dag_match_filter,
                                            description='DAG for GD IP Mappings',
                                            tag_name=None
                                            )
    result = add_address_group(device, ag_object)
    commit_exc = None
    if result and commit:
        print("Attempt to commit Dynamic Address Groups.")
        try:
            device.commit(sync=True)
        except Exception, e:
            print("Exception occurred: {}".format(e))
            commit_exc = False


def register_ip_to_tag_map(device, ip_addresses, tag):
    """

    :param device:
    :param ip_addresses:
    :param tag:
    :return:
    """

    exc = None
    try:
        device.userid.register(ip_addresses, tag)
    except Exception, e:
            exc = get_exception()

    if exc:
        return (False, exc)
    else:
        return (True, exc)

def handle_dag_ip(device, ipAddressV4, tag):

    print("Register the following IP on the FW: {} with Tag: {}".format(ipAddressV4, tag))
    result, exc = register_ip_to_tag_map(device,
                                         ip_addresses=ipAddressV4,
                                         tag=tag
                                         )

    try:
        device.commit(sync=True)
    except Exception, e:
        print("exception occurred.. {}".format(e))
    return result, exc


def check_security_rules(device):
    output = device.op("show system info")

    print("System info: {}".format(output))

    rulebase = policies.Rulebase()
    device.add(rulebase)
    current_security_rules = policies.SecurityRule.refreshall(rulebase)

    print('Current security rules: {}'.format(len(current_security_rules)))
    for rule in current_security_rules:
        print('- {}'.format(rule.name))

def get_rulebase(device):
    # Build the rulebase

    rulebase = policies.Rulebase()
    device.add(rulebase)

    policies.SecurityRule.refreshall(rulebase)
    return rulebase

def create_security_rule(**kwargs):
    security_rule = policies.SecurityRule(
        name=kwargs['rule_name'],
        description=kwargs['description'],
        fromzone=kwargs['source_zone'],
        source=kwargs['source_ip'],
        source_user=kwargs['source_user'],
        hip_profiles=kwargs['hip_profiles'],
        tozone=kwargs['destination_zone'],
        destination=kwargs['destination_ip'],
        application=kwargs['application'],
        service=kwargs['service'],
        category=kwargs['category'],
        log_start=kwargs['log_start'],
        log_end=kwargs['log_end'],
        action=kwargs['action'],
        type=kwargs['rule_type']
    )

    if 'tag_name' in kwargs:
        security_rule.tag = kwargs['tag_name']

    # profile settings
    if 'group_profile' in kwargs:
        security_rule.group = kwargs['group_profile']
    else:
        if 'antivirus' in kwargs:
            security_rule.virus = kwargs['antivirus']
        if 'vulnerability' in kwargs:
            security_rule.vulnerability = kwargs['vulnerability']
        if 'spyware' in kwargs:
            security_rule.spyware = kwargs['spyware']
        if 'url_filtering' in kwargs:
            security_rule.url_filtering = kwargs['url_filtering']
        if 'file_blocking' in kwargs:
            security_rule.file_blocking = kwargs['file_blocking']
        if 'data_filtering' in kwargs:
            security_rule.data_filtering = kwargs['data_filtering']
        if 'wildfire_analysis' in kwargs:
            security_rule.wildfire_analysis = kwargs['wildfire_analysis']
    return security_rule


def insert_rule(rulebase, sec_rule):

    print("Inserting Rule into the top spot.")
    if rulebase:
        rulebase.insert(0, sec_rule)
        sec_rule.apply_similar()
        #rulebase.apply()

def add_rule(rulebase, sec_rule):
    if rulebase:
        rulebase.add(sec_rule)
        sec_rule.create()
        return True
    else:
        return False


def update_rule(rulebase, nat_rule, commit):
    if rulebase:
        rulebase.add(nat_rule)
        nat_rule.apply()
        return True
    else:
        return False

def find_rule(rulebase, rule_name):
    # Search for the rule name
    rule = rulebase.find(rule_name)
    if rule:
        return rule
    else:
        return False

def handle_security_rule(device, rule_name, description, source_zone,
                         destination_zone, source_ip, action):

    rule_name=rule_name
    description=description
    source_zone=source_zone
    destination_zone=destination_zone
    source_ip=source_ip
    action=action

    # Get the rulebase
    print('Retrieve rulebase')
    rulebase = get_rulebase(device)
    print('Rulebase retrieved: {}'.format(rulebase))
    match = find_rule(rulebase, rule_name)
    if match:
        print('Rule \'%s\' already exists. Use operation: \'update\' to change it.' % rule_name)
    else:
        print("Create the rule..")
        try:
            print("Creating rule with name: {}".format(rule_name))
            new_rule = create_security_rule(
                rule_name=rule_name,
                description=description,
                tag_name=[],
                source_zone=source_zone,
                destination_zone=destination_zone,
                source_ip=source_ip,
                source_user=['any'],
                destination_ip=['any'],
                category=['any'],
                application=['any'],
                service=['application-default'],
                hip_profiles=['any'],
                group_profile={},
                antivirus={},
                vulnerability={},
                spyware={},
                url_filtering={},
                file_blocking={},
                data_filtering={},
                wildfire_analysis={},
                log_start=False,
                log_end=True,
                rule_type='universal',
                action=action
            )
            print("Add the rule to the FW...")
            #changed = add_rule(rulebase, new_rule)
            changed = insert_rule(rulebase, new_rule)
        except Exception, e:
            print(e)


def lambda_handler(event, context):

    print("[Lambda handler]Received event: " + json.dumps(event, indent=2))
    fw_ip = os.environ['FWIP']
    username = os.environ['USERNAME']
    password = os.environ['PASSWORD']
    untrust_zone_name = os.environ['UNTRUST_ZONE']
    trust_zone_name = os.environ['TRUST_ZONE']
    security_rule_name = os.environ['SECURITY_RULE_NAME']
    rule_action = os.environ.get('RULE_ACTION', 'deny')
    guard_duty_dag_name = os.environ.get("GD_DAG_NAME", "default_gd_dag_name")
    tag_for_gd_ips = os.environ.get("FW_DAG_TAG", "AWS:GD")

    print("Establish a connection with the firewall")
    fw = firewall.Firewall(fw_ip, username, password)

    group_name='pan_gd_dag'
    print("Process threat intelligence.")
    returned_ips = handle_gd_threat_intel(event, context)

    all_address_groups, _ = get_all_address_group(fw)
    print ("The following is a list of exists DAGS on the FW: {}".format(all_address_groups))
    if guard_duty_dag_name not in all_address_groups:
        print("DAG with name {} does not exist on the Firewall".format(group_name))
        print("Process / handle the creation of the DAG with Tag: {}".format(tag_for_gd_ips))
        handle_dags(fw, guard_duty_dag_name, tag_for_gd_ips)
    else:
        print("DAG with name {} already exists on the Firewall.".format(guard_duty_dag_name))

    print("Process / handle the creation of ip to tag registrations")
    if type(returned_ips) == list:
        for ip in returned_ips:
            print("Register IP {}".format(ip))
            handle_dag_ip(fw, ip, tag_for_gd_ips)
    else:
        print("Register First IP {}".format(returned_ips))
        handle_dag_ip(fw, returned_ips, tag_for_gd_ips)

    print("Process / handle the creation of security rules.")
    handle_security_rule(fw, security_rule_name,
                         'Rules based on Guard Duty',
                         untrust_zone_name, trust_zone_name,
                         [guard_duty_dag_name], rule_action)
    fw.commit(sync=True)
    print("All operations done...")

def local_lambda_handler(fw_ip, username, password,ipaddress_list):
    """
    This function is intended primarily for testing 
    purposes and to be invoked directly from the 
    shell. 
    
    :param fw_ip: 
    :param username: 
    :param context: 
    :return: 
    """
    fw = firewall.Firewall(fw_ip, username, password)

    group_name = 'local_pan_gd_dag'
    print("Process threat intelligence.")
    ipAddressV4 = ipaddress
    print("Process / handle the creation of DAGs")
    all_address_groups, _ = get_all_address_group(fw)
    print all_address_groups
    if group_name not in all_address_groups:
        print("DAG with name {} does not exist on the Firewall".format(group_name))
        handle_dags(fw, group_name, 'Recon:IAMUser')
    else:
        print("DAG with name {} already exists on the Firewall.".format(group_name))

    print("Process / handle the creation of ip to tag registrations")
    for ip in ipaddress_list:
        print("Register IP {}".format(ip))
        handle_dag_ip(fw, ip, 'Recon:IAMUser')
    print("Process / handle the creation of security rules.")
    handle_security_rule(fw, 'local_aws_gd_source_rules',
                         'Rules based on Guard Duty',
                         untrust_zone_name, trust_zone_name,
                         [group_name], 'deny')
    fw.commit(sync=True)
    print("All operations done...")

if __name__ == "__main__":
    if len(sys.argv) != 7:
        sys.exit("ERROR Usage: python {} <fw ip> <username> <password> <untrust zone name> <trust zone name> <ip to register>".format(sys.argv[0]))

    fw_ip = sys.argv[1]
    username = sys.argv[2]
    password = sys.argv[3]
    untrust_zone_name = sys.argv[4]
    trust_zone_name = sys.argv[5]
    ipaddress = sys.argv[6]

    gd_finding_s = json.loads(gd_finding)
    ips = local_handle_gd_threat_intel(gd_finding_s)
    print("Final retrieved IP address is: {}".format(ips))
    local_lambda_handler(fw_ip, username, password, ips)
